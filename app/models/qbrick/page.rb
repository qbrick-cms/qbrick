module Qbrick
  class Page < ActiveRecord::Base
    include ::RailsSettings::Extend
    include Qbrick::Engine.routes.url_helpers
    include Qbrick::Orderable
    include Qbrick::Translatable
    include Qbrick::BrickList
    include Qbrick::Searchable

    has_ancestry
    acts_as_brick_list

    translate :title, :page_title, :slug, :keywords, :description,
              :body, :redirect_url, :path, :published

    default_scope { order 'position ASC' }

    scope :published, -> { where locale_attr(:published) => Qbrick::PublishState::PUBLISHED }
    scope :unpublished, -> { where.not locale_attr(:published) => Qbrick::PublishState::PUBLISHED }
    scope :translated, -> { where.not locale_attr(:path) => [nil, ''], locale_attr(:title) => [nil, ''] }

    scope :content_page, -> { where page_type: Qbrick::PageType::CONTENT }

    scope :navigation, lambda { |slug|
      where(
        locale_attr(:slug) => slug,
        locale_attr(:page_type) => Qbrick::PageType::NAVIGATION)
    }

    before_validation :create_slug, :create_path
    after_save :update_child_paths
    validate :remove_preceding_slashes, if: :redirect?

    validates :title, presence: true
    validates :slug, presence: true
    validates :redirect_url, presence: true, if: :redirect?
    validates :title, :slug, :keywords, :page_type, length: { maximum: 255 }
    validates :identifier, uniqueness: true, allow_blank: true
    validate :slug_uniqueness

    class << self
      def flat_tree
        arrange_as_array
      end

      def arrange_as_array(options = {}, hash = nil)
        hash ||= arrange(options)

        arr = []
        hash.each do |node, children|
          arr << node
          arr += arrange_as_array(options, children) unless children.empty?
        end

        arr
      end

      def by_identifier(identifier)
        find_by(identifier: identifier)
      end

      def all_paths
        path_columns = column_names.select { |col| col.start_with? 'path_' }
        pluck(*path_columns).flatten.compact.sort.uniq.map(&:path)
      end

      def find_by_path(given_path)
        find_by locale_attr(:path) => given_path.blank? ? '' : "/#{given_path.sub(%r{^/+}, '')}"
      end
    end # class methods

    def slug_uniqueness
      path_field = locale_attr :path
      slug_field = locale_attr :slug
      [slug_field, path_field].each do |field|
        self.class.validators_on(field).map { |v| v.validate self }
        return true if errors[field].present?
      end

      page_with_duplicated_paths = self.class.published.translated.where path_field => path
      page_with_duplicated_paths = page_with_duplicated_paths.where.not id: id if persisted?
      return true unless page_with_duplicated_paths.exists?

      message = 'page ids: '
      page_with_duplicated_paths.order(:id).pluck(:id).each do |id|
        message << "<a href=\"#{edit_cms_page_path id}#page-metadata\" target=\"_blank\">#{id}</a>, "
      end
      message = I18n.t 'activerecord.errors.models.qbrick/page.attributes.slug.duplicated_slug', append: " (#{message.sub(/, $/, '')})"
      errors.add :slug, message.html_safe
    end

    def without_self
      self.class.where.not id: id
    end

    def published?
      published == Qbrick::PublishState::PUBLISHED && !ancestors.unpublished.present?
    end

    def state_class
      published? ? 'published' : 'unpublished'
    end

    def redirect?
      page_type == Qbrick::PageType::REDIRECT || page_type == Qbrick::PageType::CUSTOM
    end

    def internal_redirect?
      return false unless redirect?

      scheme = URI.parse(redirect_url).scheme
      return true if scheme.nil?

      internal_redirect = Qbrick::Engine.hosts.find do |h|
        URI.parse("#{scheme}://#{h}").route_to(redirect_url).host.nil?
      end

      internal_redirect.present?
    end

    def external_redirect?
      redirect? && !internal_redirect?
    end

    def remove_preceding_slashes
      return if redirect_url.blank?

      redirect_url.sub!(%r{^/+}, '/')
    end

    def navigation?
      page_type == Qbrick::PageType::NAVIGATION
    end

    def parent_pages
      ancestors
    end

    def translated?
      title.present? && slug.present?
    end

    def translated_to?(raw_locale)
      locale = raw_locale.to_s.underscore
      send("title_#{locale}").present? && send("slug_#{locale}").present?
    end

    def translated_link_for(locale)
      return Qbrick::Page.roots.first.link unless translated_to? locale

      I18n.with_locale locale do
        path_with_prefixed_locale
      end
    end

    def link
      return children.published.first.link if bricks.empty? && children.any?

      path_with_prefixed_locale
    end

    def path_segments
      paths = parent.present? ? parent.path_segments : []
      paths << slug unless navigation?
      paths
    end

    def path_with_prefixed_locale(locale = I18n.locale)
      "/#{locale}#{send self.class.attr_name_for_locale(:path, locale)}"
    end

    def url
      URI::HTTP.build([nil, Qbrick::Engine.host, Qbrick::Engine.port, path_with_prefixed_locale, nil, nil]).tap do |url|
        url.scheme = Qbrick::Engine.scheme
      end
    end

    def create_path
      opts = { locale: I18n.locale }
      path = path_segments.join '/'
      opts[:url] = path if path.present?

      self.path = page_path(opts).sub(%r{^/#{I18n.locale}}, '')
    end

    def create_slug
      if title.present? && slug.blank?
        self.slug = title.downcase.parameterize
      elsif slug.present?
        self.slug = slug.downcase.parameterize
      end
    end

    def update_child_paths
      children.each do |child|
        child.update_attribute :path, child.create_path
      end
    end

    def nesting_name
      num_dashes = parent_pages.size
      num_dashes = 0 if num_dashes < 0
      "#{'-' * num_dashes} #{title}".strip
    end

    def brick_list_type
      'Qbrick::Page'
    end

    def to_style_class
      'qbrick-page'
    end

    def allowed_brick_types
      Qbrick::BrickType.enabled.pluck(:class_name) - ['Qbrick::AccordionItemBrick']
    end

    def cache_key
      super + bricks.map(&:cache_key).join
    end

    def as_json
      { 'title' => title, 'pretty_url' => path, 'url' => "/pages/#{id}" }
    end

    def clear_bricks_for_locale(locale)
      I18n.with_locale locale do
        bricks.destroy_all
      end
    end

    def copy_assets_to_cloned_brick(brick, new_brick)
      uploader_keys = brick.class.uploaders.keys
      multipart_checks = uploader_keys.map { |key| [key, brick.class.uploaders.send(:[], key).ensure_multipart_form] }
      asset_attributes = uploader_keys.map { |key| [key, brick.send(key).path] }

      multipart_checks.each do |uploader_key, _multipart_check|
        brick.class.uploaders.send(:[], uploader_key).ensure_multipart_form = false
      end

      new_brick.update_attributes Hash[asset_attributes]

      multipart_checks.each do |uploader_key, multipart_check|
        brick.class.uploaders.send(:[], uploader_key).ensure_multipart_form = multipart_check
      end
    end

    def clone_child_bricks(brick, to_locale, new_brick_list_id)
      brick.bricks.each do |nested_brick|
        clone_brick_to(nested_brick, to_locale, new_brick_list_id)
      end
    end

    def clone_bricks_to(locale)
      failed_to_clone = []
      clear_association_cache

      bricks.each do |brick|
        failed_to_clone << brick unless clone_brick_to(brick, locale, id)
      end
      failed_to_clone
    end

    def clone_brick_to(brick, to_locale, new_brick_list_id)
      new_brick = brick.deep_dup

      copy_assets_to_cloned_brick(brick, new_brick) if brick.uploader?

      new_brick.update_attributes(locale: to_locale, brick_list_id: new_brick_list_id)

      clone_child_bricks(brick, to_locale, new_brick.id) if brick.respond_to?(:bricks)

      new_brick.save validate: false
    end
  end
end

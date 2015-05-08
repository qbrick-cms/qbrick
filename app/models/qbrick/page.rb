module Qbrick
  class Page < ActiveRecord::Base
    include Qbrick::Engine.routes.url_helpers
    include Qbrick::Orderable
    include Qbrick::Translatable
    include Qbrick::BrickList
    include Qbrick::Searchable

    has_ancestry
    acts_as_brick_list

    translate :title, :page_title, :slug, :keywords, :description,
              :body, :redirect_url, :url

    default_scope { order 'position ASC' }

    scope :published, -> { where published: Qbrick::PublishState::PUBLISHED }
    scope :translated, -> { where "url_#{I18n.locale.to_s.underscore} is not null" }

    scope :content_page, -> { where page_type: Qbrick::PageType::CONTENT }

    scope :navigation, lambda { |slug|
      where(
        locale_attr(:slug) => slug,
        locale_attr(:page_type) => Qbrick::PageType::NAVIGATION)
    }

    before_validation :create_slug, :create_url
    after_save :update_child_urls

    validates :title, presence: true
    validates :slug, presence: true
    validates :redirect_url, presence: true, if: :redirect?
    validates :title, :slug, :keywords, :page_type, length: { maximum: 255 }
    validates :identifier, uniqueness: true, allow_blank: true

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

      def all_urls
        url_columns = column_names.select { |col| col.start_with? 'url_' }
        pluck(*url_columns).flatten.compact.sort.uniq.map { |r| "/#{r}" }
      end
    end

    def without_self
      self.class.where 'id != ?', id
    end

    def published?
      published == Qbrick::PublishState::PUBLISHED
    end

    def state_class
      published? ? 'published' : 'unpublished'
    end

    def redirect?
      page_type == Qbrick::PageType::REDIRECT || page_type == Qbrick::PageType::CUSTOM
    end

    def navigation?
      page_type == Qbrick::PageType::NAVIGATION
    end

    def parent_pages
      ancestors
    end

    def translated?
      url.present? && title.present? && slug.present?
    end

    def translated_to?(raw_locale)
      locale = raw_locale.to_s.underscore
      send("url_#{locale}").present? && send("title_#{locale}").present? && send("slug_#{locale}").present?
    end

    def translated_link_for(locale)
      if translated_to? locale
        I18n.with_locale locale do
          url_with_locale
        end
      else
        Qbrick::Page.roots.first.link
      end
    end

    def link
      if bricks.count == 0 && children.count > 0
        children.first.link
      else
        url_with_locale
      end
    end

    # TODO: needs naming and routing refactoring (url/locale/path/slug)
    def path_segments
      paths = parent.present? ? parent.path_segments : []
      paths << slug unless navigation?
      paths
    end

    def url_without_locale
      path_segments.join('/')
    end

    def url_with_locale
      opts = { locale: I18n.locale }
      url = url_without_locale
      opts[:url] = url if url.present?
      page_path(opts)
    end

    def create_url
      self.url = url_with_locale[1..-1]
    end

    def create_slug
      if title.present? && slug.blank?
        self.slug = title.downcase.parameterize
      elsif slug.present?
        self.slug = slug.downcase
      end
    end

    def update_child_urls
      return unless children.any?
      children.each { |child| child.update_attributes(url: child.create_url) }
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
      {}.tap do |json|
        json['title'] = send("title_#{I18n.locale.to_s.underscore}")
        json['pretty_url'] = '/' + send("url_#{I18n.locale.to_s.underscore}")
        json['url'] = "/pages/#{id}"
      end
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

      multipart_checks.each do |uploader_key, multipart_check|
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

      new_brick.save
    end
  end
end

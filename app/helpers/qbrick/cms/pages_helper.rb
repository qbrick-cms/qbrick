module Qbrick
  module Cms
    module PagesHelper
      MAIN_NAVIGATION = [
        [Qbrick::Page.model_name.human(count: 2), 'page', :cms_pages_path],
        [Qbrick::Setting.model_name.human(count: 2), 'settings', :cms_settings_collections_path],
        [Qbrick::Admin.model_name.human(count: 2), 'people', :cms_admins_path]
      ]

      def content_tab_active(page)
        :active unless hide_content_tab?(page)
      end

      def metadata_tab_active(page)
        :active if hide_content_tab?(page)
      end

      def hide_content_tab?(page)
        page.redirect? || !page.translated? || !page.persisted? || page.errors.present?
      end

      def main_navigation_list
        haml_tag :ul, class: 'iconbar__list' do
          MAIN_NAVIGATION.each do |title, icon, path_method|
            path = URI(qbrick.send path_method).path
            css_classes = ['iconbar__item', request.path.start_with?(path) ? 'iconbar__item--active' : nil]

            haml_tag :li, class: css_classes.compact.join(' ') do
              haml_concat main_nav_link title, icon, path
            end
          end
        end
      end

      def main_nav_link(name, icon, path)
        link_to path do
          streusel_icon icon
          haml_concat name
        end
      end
    end
  end
end

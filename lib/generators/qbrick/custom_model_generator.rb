require 'rails/generators'

module Qbrick
  class CustomModelGenerator < Rails::Generators::Base
    def source_paths
      [
        File.join(File.dirname(__FILE__), '../../../app/views/qbrick/cms/admin/'),
        File.join(File.dirname(__FILE__), '../../templates/qbrick/', self.class.name.demodulize.underscore)
      ]
    end

    def set_up_custom_models_base
      unless custom_models_base_already_installed?
        setup_base_controller
        setup_base_views
        setup_navigation
        setup_translation_file
      end
    end


    private

    def custom_models_base_already_installed?
      File.exists?('app/controllers/qbrick/base_controller.rb') && File.exists?('app/views/qbrick/cms/admin/_main_navigation.html.haml')
    end

    def setup_base_controller
      empty_directory 'app/controllers/qbrick'
      template 'base_controller.rb', 'app/controllers/qbrick/base_controller.rb'
    end

    def setup_base_views
      directory 'inherited_views', 'app/views/qbrick'
    end

    def setup_navigation
      nav_dir = 'app/views/qbrick/cms/admin'
      empty_directory nav_dir

      copy_file '_main_navigation.html.haml', "#{nav_dir}/_main_navigation.html.haml"
    end

    def setup_translation_file
      empty_directory 'config/locales/de'
      copy_file 'translations/qbrick_base.yml', 'config/locales/de/qbrick_base.yml'
    end
  end
end

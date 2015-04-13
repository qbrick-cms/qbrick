require 'rails/generators'

module Qbrick
  class CustomModelGenerator < Rails::Generators::NamedBase
    def source_paths
      [
        File.join(File.dirname(__FILE__), '../../../app/views/qbrick/cms/backend/'),
        File.join(File.dirname(__FILE__), '../../templates/qbrick/', self.class.name.demodulize.underscore)
      ]
    end

    def set_up_custom_models_base
      return if custom_models_base_already_installed?

      setup_base_controller
      setup_base_views
      setup_navigation
      setup_translation_file
    end

    def add_route
      generate 'resource_route', resource_route_name
    end

    def add_navigation_link
      nav_file = 'app/views/qbrick/cms/backend/_main_navigation.html.haml'

      inject_into_file nav_file, after: '%li= link_to Qbrick::Page.model_name.human(:count => 2), qbrick.cms_pages_path' do
        "\n  %li= link_to t('cms.navigation_title.#{model_name}'), #{route_name}_path"
      end
    end

    def add_model_and_migration
      generate 'model', model_name, ARGV[1..-1].join(' '), '--no-test-framework'
      inject_into_file "app/models/#{model_name}.rb", before: 'class' do
        "require 'qbrick/cms_model'\n\n"
      end

      inject_into_file "app/models/#{model_name}.rb", before: 'end' do
        <<-eos.gsub(/^ {8}/, '').chomp
          include Qbrick::CMSModel

          # TODO: Define what attributes are shown in the form and permitted by strong parameters
          editable_attributes #{attribute_keys_as_string}

          # TODO: Define what attributes are shown in the index view
          index_attributes #{attribute_keys_as_string}

         eos
      end
    end

    def add_resource_translations
      I18n.available_locales.each do |locale|
        I18n.with_locale(locale) do
          template 'translations/resource.yml.erb', "config/locales/#{locale}/#{model_name}.yml"
        end
      end
    end

    def add_controller
      generate 'controller', controller_name, '--no-helper --no-assets --no-test-framework'
      gsub_file "app/controllers/#{controller_name}_controller.rb", 'ApplicationController', 'Qbrick::BaseController'
    end

    private

    def custom_models_base_already_installed?
      File.exist?('app/controllers/qbrick/base_controller.rb') && File.exist?('app/views/qbrick/cms/backend/_main_navigation.html.haml')
    end

    def setup_base_controller
      empty_directory 'app/controllers/qbrick'
      template 'base_controller.rb', 'app/controllers/qbrick/base_controller.rb'
    end

    def setup_base_views
      directory 'inherited_views', 'app/views/qbrick'
    end

    def setup_navigation
      nav_dir = 'app/views/qbrick/cms/backend'
      empty_directory nav_dir

      copy_file '_main_navigation.html.haml', "#{nav_dir}/_main_navigation.html.haml"
    end

    def setup_translation_file
      empty_directory 'config/locales/de'
      copy_file 'translations/qbrick_base.yml', 'config/locales/de/qbrick_base.yml'
    end

    def resource_route_name
      "cms/#{model_name}"
    end

    def model_name
      ARGV.first.downcase
    end

    def controller_name
      "cms/#{model_name.pluralize}"
    end

    def route_name
      controller_name.gsub('/', '_')
    end

    def attributes
      ARGV[1..-1].map { |x| x.split(':').first }
    end

    def attribute_keys_as_string
      ARGV[1..-1].map { |a| ":#{a.split(':').first}" }.join(', ')
    end
  end
end

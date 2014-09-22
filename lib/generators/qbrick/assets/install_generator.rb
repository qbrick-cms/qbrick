require 'rails/generators'

module Qbrick
  module Assets
    class Install < Rails::Generators::Base
      source_root(File.join(Qbrick::Engine.root, '/lib/templates/qbrick/assets'))

      def copy_customizations
        custom_css_folder = 'app/assets/stylesheets/qbrick/cms/'
        custom_js_folder = 'app/assets/javascripts/qbrick/cms/'

        empty_directory custom_css_folder
        empty_directory custom_js_folder

        copy_file 'customizations.css.sass', "#{custom_css_folder}/customizations.css.sass"
        copy_file 'customizations.js.coffee', "#{custom_js_folder}/customizations.js.coffee"
        copy_file 'ck-config.js.coffee', "#{custom_js_folder}/ck-config.js.coffee"

        inject_into_file 'config/environments/production.rb', after: /config\.assets\.precompile.*$/ do
          "\n  config.assets.precompile += %w( qbrick/cms/customizations.css qbrick/cms/customizations.js )"
        end
      end
    end
  end
end

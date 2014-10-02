require 'spec_helper'
require 'features_helper'
require_relative '../command_wrapper_helper.rb'

describe 'rails generate qbrick:custom_model', generator: true do

  let(:cars_controller) { application_file 'app/controllers/cms/cars_controller.rb' }

  it 'is available in the generated app' do
    cli_output = rails 'generate'
    expect(cli_output).to match(/qbrick:custom_model/)
  end

  context 'generating a cms resource' do
    before :all do
      rails 'destroy scaffold cms/car'
      rails 'destroy scaffold car'
      `rm -rf #{File.join test_app_path, 'db/migrate/*_cars*'}`
      rails 'generate qbrick:custom_model car tires:integer model:string'
    end

    after :all do
      drop_qbrick_scaffold_for('car')
      `rm #{File.join test_app_path, 'app/controllers/qbrick/base_controller.rb'}`
      `rm -r #{File.join test_app_path, 'app/views/qbrick'}`
      `rm -r #{File.join test_app_path, 'config/locales/de'}`
    end

    context 'for the first time' do
      it 'sets up the cms routes namespace' do
        expect(application_file('config/routes.rb')).to match(/namespace :cms do/)
      end

      it 'generates inherited resource views' do
        views = Dir[File.join(test_app_path, 'app/views/qbrick/base/*.html.haml')]
        views.map! { |v| v.scan(%r{^.+app/views/qbrick/base/(.*).html.haml}).flatten.first.to_sym }
        expected_action_views = [:edit, :index, :new, :"_form"]
        expect(expected_action_views - views).to be_empty
      end
    end

    context 'generates a CRUD controller' do
      it 'inherits from the qbrick base controller' do
        expect(application_file('app/controllers/cms/cars_controller.rb')).to match(/Qbrick..BaseController/)
      end
    end

    it 'generates a model' do
      expect(application_file('app/models/car.rb')).not_to be_nil
    end

    it 'uses the fields given in the command line to pre-fill editable and index attributes' do
      expect(application_file('app/models/car.rb')).to match('editable_attributes :tires, :model')
      expect(application_file('app/models/car.rb')).to match('index_attributes :tires, :model')
    end

    it 'generates a migration' do
      expect(Dir.glob("#{test_app_path}/db/migrate/*create*cars*").size).to be 1
    end

    it 'adds a resource route' do
      expect(application_file('config/routes.rb')).to match(/resources :cars/)
    end

    it 'does not generate routing specs' do
      routing_spec = File.join(test_app_path, 'spec/routing/cars_routing_spec.rb')
      expect(File.exist? routing_spec).to be(false)
    end

    it 'does not generate view specs' do
      view_specs = File.join(test_app_path, 'spec/views/cars')
      expect(File.exist? view_specs).to be(false)
    end

    it 'does not generate controller specs' do
      controller_specs = File.join(test_app_path, 'spec/controllers/cars_controller_spec.rb')
      expect(File.exist? controller_specs).to be(false)
    end

    it 'does not generate json views' do
      expect(Dir.glob("#{test_app_path}/app/views/cars/*.jbuilder").size).to be 0
    end

  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] = 'test'
require_relative File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'

[
  'factory_girl',
  'capybara/rails',
  'pry-byebug',
  'database_cleaner'
].each { |lib| require lib }

FactoryGirl.find_definitions

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = 'test.com'
ActiveRecord::Migrator.migrations_paths = 'spec/dummy/db/migrate'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require_relative f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema! if ActiveRecord::Migration.respond_to? :maintain_test_schema!

include Warden::Test::Helpers
Warden.test_mode!

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  require 'carrierwave/test/matchers'
  require 'rails/generators'

  config.include RSpec::Matchers
  config.include CarrierWave::Test::Matchers
  config.include QbrickSpecHelper
  config.include FactoryGirl::Syntax::Methods
  config.include Rails.application.routes.url_helpers

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.before do
    DatabaseCleaner.start
    Qbrick::ImageSize.build_defaults!
    I18n.available_locales = [:en, :de]
  end

  config.after do
    DatabaseCleaner.clean
  end

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.filter_run_excluding generator: true
end

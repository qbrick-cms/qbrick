begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'
require 'rspec/core/rake_task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Qbrick'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

desc 'Run specs'
RSpec::Core::RakeTask.new(spec: :setup)

desc 'set up the dummy app for testing'
task :setup do
  #Postgres.create_user 'screenconcept'
  #within_dummy_app do
    #`bundle exec rake qbrick:install:migrations`
    #`bundle exec rails generate qbrick:install:assets`
    #`bundle exec rake db:drop`
    #`bundle exec rake db:create`
    #`bundle exec rake db:migrate`
    #`bundle exec rake db:test:prepare`
  #end
end

task default: :rspec

require_relative './postgres_helper'

def test_app_path
  File.expand_path(File.join(File.dirname(__FILE__), '../spec/dummy'))
end

def reload_application_gemfile
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
end

def application_file_path(file)
  File.join test_app_path, file
end

def application_file(file)
  File.read(application_file_path file)
end

def drop_qbrick_scaffold_for(name)
  app_path = test_app_path
  unless File.exist? app_path
    puts "won't destroy scaffold for #{name.inspect} while app #{app_path} doesn't exist."
    return
  end

  Dir.chdir(app_path) do
    database_name = app_path.split('/').last
    rails "destroy scaffold #{name}"
    rails "destroy scaffold #{name.pluralize}"
    rails "destroy scaffold cms/#{name.pluralize}"
    database = "#{database_name}_test"
    next unless Postgres.database_exists? database

    Postgres.drop_table database_name, database, name
  end
end

namespace :kuhsaft do
  def qbrick_migration_path
    return @qbrick_migration_path if @qbrick_migration_path.present?

    migration_name = 'RenameKuhsaftNamespaceToQbrick'

    migration_path = migrations.find { |name, _path| name.match(/^#{migration_name.underscore}($|\.)/) }
    if migration_path.present?
      migration_path = migration_path.last
    else
      migration_path = Rails::Generators.invoke('active_record:migration', [migration_name]).try :first
    end
    @qbrick_migration_path = migration_path.present? ? Rails.root.join(migration_path) : nil
  end

  def add_qbrick_migration_line(line)
    content = File.read qbrick_migration_path
    return if content.split("\n").map(&:strip).include? line.strip

    line << "\n" unless line.end_with? "\n"
    content.sub! /(def change$)/m, "\\1\n    #{line}"
    File.open(qbrick_migration_path, 'w') { |file| file.write content }
  end

  desc 'Try to automate parts of a migration to Qbrick'
  namespace :migrate_to_qbrick do
    desc 'Rename STI class references'
    task rename_sti_references: :environment do
      str = <<-RUBY
    Kuhsaft::Engine.eager_load! if defined? Kuhsaft
    Qbrick::Engine.eager_load! if defined? Qbrick
    Rails.application.eager_load!

    ActiveRecord::Base.descendants.select do |model|
      next unless model.table_exists?

      column_names = model.column_names
      type_columns = []
      type_columns << 'brick_list_type' if column_names.include? 'brick_list_type'
      type_columns << 'class_name' if column_names.include? 'class_name'

      type_columns << model.inheritance_column.to_s if model.respond_to?(:inheritance_column) &&
                                                       column_names.include?(model.inheritance_column.to_s)

      type_columns.each do |type_column|
        type_condition = ["#{type_column} LIKE ?", 'Kuhsaft%']

        legacy_records = model.unscoped.where(*type_condition)
        next unless legacy_records.any?

        legacy_records.distinct(type_column).pluck(type_column).each do |old_type|
          new_type = old_type.sub(/^Kuhsaft/, 'Qbrick')
          print "Renaming STI entries of #{model.name} from #{old_type} to #{new_type} in column #{type_column}"
          count = model.unscoped.update_all({ type_column => new_type }, type_column => old_type)

          print " (#{count})."
          puts 'done.'
        end
      end
    end
      RUBY
      str.split("\n").each { |line| add_qbrick_migration_line line }
    end

    desc 'Tries to generate migrations for renaming ActiveRecord tables'
    task generate_migrations: :environment do
      require 'rails/generators'
      require 'rails/generators/active_record'
      require 'rails/generators/actions/create_migration'

      defined?(Kuhsaft) ? Kuhsaft::Engine.eager_load! : Qbrick::Engine.eager_load!
      Rails.application.eager_load!
      renames = []

      db = ActiveRecord::Base.connection
      db.tables.each do |table_name|
        next unless table_name.start_with? 'kuhsaft'

        renames << "rename_table '#{table_name}', '#{table_name.sub(/^kuhsaft/, 'qbrick')}' if table_exists? '#{table_name}'"
      end

      migrations = []
      ActiveRecord::Migrator.migrations_paths.each do |path|
        Dir.foreach(path).grep(/^\d{3,}_(.+)\.rb$/) { |filename| migrations << [Regexp.last_match(1), File.join(path, filename)] }
      end
      migrations = Hash[migrations]

      kuhsaft_migrations = migrations.select { |name, _path| name.end_with? '.kuhsaft' }
      qbrick_migrations = migrations.keys.map { |n| n.split('.').first.camelcase if n.end_with? '.qbrick' }.compact.uniq
      kuhsaft_migrations.each do |kuhsaft_name, _path|
        qbrick_name = kuhsaft_name.split('.').first.gsub('kuhsaft', 'qbrick').camelcase
        next if !qbrick_name.match(/qbrick/i) || qbrick_migrations.include?(qbrick_name)

        migration_path = Rails::Generators.invoke('active_record:migration', [qbrick_name]).try :first
        migration_path =  migration_path
        next if migration_path.blank? || !File.exists?(migration_path)

        content = File.read(migration_path).sub(/(def change[^\z]*)/m, "def change\n  end\nend\n")
        File.open(migration_path, 'w') { |file| file.write content }
        File.rename migration_path, migration_path.sub(/(\.rb)$/, '.qbrick\1')
      end

      renames.each { |rename| add_qbrick_migration_line rename }
      puts 'You still have to call $ rake db:migrate manually.'
    end

    def rename(old_name, new_name, has_git = true)
      return File.rename old_name, new_name unless has_git

      system %(git mv "#{old_name}" "#{new_name}")
    rescue => _e
      File.rename old_name, new_name
    end

    desc 'Renames "Kuhsaft" with "Qbrick" and will most probable brake things'
    task rename_classes_and_directories: :environment do
      has_git = system('git status').present?
      ignored_paths = %r{^(vendor|log|doc|db|bin|Gemfile|spec/cassettes|spec/fixtures)}

      Dir.glob('**/*').each do |dir|
        next if !File.directory?(dir) || !dir.split('/').last.include?('kuhsaft') ||
                dir.match(ignored_paths)

        rename dir, dir.sub('kuhsaft', 'qbrick'), has_git
      end

      Dir.glob('**/*').each do |filename|
        next if File.directory?(filename) || !filename.split('/').last.include?('kuhsaft') ||
                filename.match(ignored_paths) || __FILE__.end_with?(filename)

        rename filename, filename.sub('kuhsaft', 'qbrick'), has_git
      end

      allowed_extensions = %w(Guardfile Rakefile rb html css coffee erb haml js json ru sass yml)
      files = Dir.glob('**/*').reject do |file_path|
        !allowed_extensions.include?(file_path.split('.').last) ||
          File.directory?(file_path) || __FILE__.end_with?(file_path) ||
          (!file_path.end_with?('db/seeds.rb') && file_path.match(ignored_paths))
      end

      files.each do |filename|
        src = File.read filename
        next unless src.include? 'uhsaft'

        puts "Replacing the word 'Kuhsaft' with 'Qbrick' in #{filename}"
        File.open(filename, 'w') do |f|
          f.write src.gsub('kuhsaft', 'qbrick').gsub('Kuhsaft', 'Qbrick')
            .gsub('Shoestrap', 'Qbrick')
            .gsub('Qbrick::Cms::AdminController', 'Qbrick::Cms::AdminsController')
        end
      end
    end

    task all: :environment do
      %w(
        rename_sti_references
        generate_migrations
        rename_classes_and_directories
      ).each do |task|
        puts "invoking #{task}"
        Rake::Task["kuhsaft:migrate_to_qbrick:#{task}"].invoke
        puts "task #{task} finished"
      end
    end
  end
end

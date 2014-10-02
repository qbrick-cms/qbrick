module Postgres
  class << self
    def exec(query, opts = {})
      command = ["psql -tAc \"#{query}\""]

      if opts.is_a?(Hash)
        opts.each_pair { |k, v| command << "--#{k}=#{v}" }
      else
        command << opts
      end

      command = command.join(' ')
      result = `#{command}`
      if result.match(/psql: FATAL:  database .+ does not exist/)
        if result.include?("psql: FATAL:  database \"#{`whoami`.strip}\" does not exist")
          `createdb`
          dbg_comment 'user database was missing. I created it for you and recall the postgres command again. :)'
          `#{command}`
        end
      else
        result
      end
    end

    def user_exists?(username)
      exec("SELECT 1 FROM pg_user WHERE usename='#{username}'", dbname: 'postgres').strip == '1'
    end

    def database_exists?(name)
      exec("SELECT 1 from pg_database WHERE datname='#{name}'", dbname: 'postgres').strip == '1'
    end

    def drop_user(username)
      `dropuser #{username}`
    end

    def drop_table(user, database, name)
      exec("SET client_min_messages TO WARNING; DROP TABLE IF EXISTS #{name};", username: user, dbname: database)
    end

    def select_users_like(username)
      exec("SELECT usename FROM pg_user where usename LIKE '#{username}'", dbname: 'postgres').split("\n").map(&:strip)
    end

    def select_databases_like(name)
      exec("SELECT datname FROM pg_database WHERE datistemplate = false AND datname LIKE '#{name}';", dbname: 'postgres').split("\n").map(&:strip)
    end

    def drop_databases_like(name)
      select_databases_like(name).each { |dbname| `dropdb #{dbname}` }
    end

    def drop_users_like(username)
      select_users_like(username).each { |u| drop_user u if user_exists?(u) }
    end

    def create_user(username)
      if user_exists?(username)
        false
      else
        puts "#{ts} $ createuser -s #{username}" if debug_shoestrap?
        `createuser -s #{username}`
      end
    end
  end
end

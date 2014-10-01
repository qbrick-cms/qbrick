require 'rails/generators'

module Shoestrap
  class BaseGenerator < Rails::Generators::Base
    def source_paths
      [File.join(File.dirname(__FILE__), '../../../templates/', self.class.name.demodulize.underscore)]
    end

    private

    def kuhsaft_is_installed?
      @kuhsaft_is_installed ||= !!defined?(Kuhsaft)
    end

    def shoestrap_logger
      self.class.shoestrap_logger
    end

    class << self
      def shoestrap_logger
        return @shoestrap_logger if @shoestrap_logger.present?
        if File.writable? '/tmp'
          logfile = File.open("/tmp/shoestrap_#{(rails_root.split('/').last || '').gsub(/\W/, '_')}", 'a')
          logfile.sync = true
          @shoestrap_logger = Logger.new(logfile)
        end
        (@shoestrap_logger || Logger.new(STDOUT)).tap do |logger|
          logger.level = Logger::DEBUG
        end
      end

      private

      def rails_root
        if defined?(Rails) && Rails.respond_to?(:root)
          Rails.root.to_s
        elsif defined?(RAILS_ROOT)
          RAILS_ROOT
        else
          Dir.getwd
        end
      end
    end
  end
end

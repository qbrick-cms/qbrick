module Qbrick
  class ImageSizeDelegator
    def method_missing(method, *args, &block)
      Qbrick::ImageSize.send(method, *args, &block)
    rescue NoMethodError
      super
    end
  end

  class Engine < ::Rails::Engine
    isolate_namespace Qbrick

    config.i18n.fallbacks = [:de]
    config.i18n.load_path += Dir[Qbrick::Engine.root.join('config/locales/**/*.{yml}').to_s]

    # defaults to nil
    config.sublime_video_token = nil

    # delegate image size config to ImageSize class
    config.image_sizes = ImageSizeDelegator.new

    config.to_prepare do
      Dir.glob(Qbrick::Engine.root.join 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency c
      end
    end

    initializer 'qbrick.initialize_haml_dependency_tracker' do
      require 'action_view/dependency_tracker'
      ActionView::DependencyTracker.register_tracker :haml, ActionView::DependencyTracker::ERBTracker
    end

    def app_config
      Rails.application.config
    end

    def hosts
      [Socket.gethostname, 'localhost'].tap do |result|
        result.concat [app_config.hosts].flatten if app_config.respond_to? :hosts
        result.concat [app_config.host].flatten if app_config.respond_to? :host
        result.compact!
        result.uniq!
      end
    end

    def host
      return hosts.first unless app_config.respond_to? :host

      app_config.host
    end

    def scheme
      return 'http' unless app_config.respond_to? :scheme

      app_config.scheme
    end

    def port
      return 80 unless app_config.respond_to? :port

      app_config.port
    end
  end
end

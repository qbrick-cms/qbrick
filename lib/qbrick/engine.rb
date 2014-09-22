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
    config.i18n.load_path += Dir[Qbrick::Engine.root.join('config', 'locales', '**', '*.{yml}').to_s]

    # defaults to nil
    config.sublime_video_token = nil

    # delegate image size config to ImageSize class
    config.image_sizes = ImageSizeDelegator.new

    initializer 'qbrick.initialize_haml_dependency_tracker' do
      require 'action_view/dependency_tracker'
      ActionView::DependencyTracker.register_tracker :haml, ActionView::DependencyTracker::ERBTracker
    end
  end
end

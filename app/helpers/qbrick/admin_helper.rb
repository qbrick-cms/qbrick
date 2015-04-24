module Qbrick
  module AdminHelper
    #
    # When rendering the layout of our host application,
    # the paths of the host application are not visible to the engine
    # therefore we delegate all failing helper calls to 'main_app',
    # which is our host application
    #
    def method_missing(method, *args, &block)
      main_app.send(method, *args, &block)
    rescue NoMethodError
      super
    end

    def sublime_video_include_tag
      token = Qbrick::Engine.config.sublime_video_token
      javascript_include_tag "//cdn.sublimevideo.net/js/#{token}-beta.js"
    end

    def streusel_icon(name, classes = '')
      haml_tag :svg, xmlns: 'http://www.w3.org/2000/svg', title: "#{name}", class: "icon icon--#{name} #{classes}" do
        haml_tag :use, 'xlink:href' => "#icon--#{name}"
      end
    end

    def current_locale?(given_locale)
      [I18n.locale.to_s, I18n.locale.to_sym].include? given_locale
    end
  end
end

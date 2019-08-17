module Qbrick
  class Engine < ::Rails::Engine
    isolate_namespace Qbrick
    initializer "webpacker.proxy" do |app|
        insert_middleware = begin
                            Qbrick.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end
        next unless insert_middleware

        app.middleware.insert_before(
          0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
          ssl_verify_none: true,
          webpacker: Qbrick.webpacker
        )
      end
  end
end

RailsSettingsUi.parent_controller = 'Qbrick::Cms::BackendController'
RailsSettingsUi::ApplicationController.layout 'qbrick/cms/application'

RailsSettingsUi.setup do |config|
  config.settings_class = 'Qbrick::Settings'
end

Rails.application.config.to_prepare do
  RailsSettingsUi.inline_main_app_routes!
end

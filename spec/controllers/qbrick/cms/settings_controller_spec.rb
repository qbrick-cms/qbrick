require 'spec_helper'

describe Qbrick::Cms::SettingsController, type: :controller do
  render_views
  routes { Qbrick::Engine.routes }

  before do
    admin = double 'admin'
    allow_message_expectations_on_nil
    allow(request.env['warden']).to receive(:authenticate!) { admin }
    allow(controller).to receive(:current_admin) { admin }
  end

  describe 'GET index' do
    it 'renders saved settings' do
      Qbrick::Settings.highlighting_font = 'Comic Sans'
      get :index
      expect(response).to be_success
      expect(response.body).to include(I18n.t 'settings.attributes.highlighting_font.name')
    end

    it 'renders default settings' do
      Qbrick::Settings.defaults[:highlighting_font] = 'Comic Sans'
      get :index
      expect(response).to be_success
      expect(response.body).to include(I18n.t 'settings.attributes.highlighting_font.name')
    end
  end

  describe 'POST update_all' do
    it 'updates settings' do
      Qbrick::Settings.defaults[:highlighting_font] = 'Comic Sans'
      post :update_all, settings: { 'highlighting_font' => 'Comic Sans Neue' }
      expect(response).to redirect_to("#{Qbrick::Engine.routes.url_helpers.cms_settings_path}?content_locale=#{I18n.locale}")
      setting = Qbrick::Settings.find_by var: 'highlighting_font'
      expect(setting.value).to eq 'Comic Sans Neue'
    end
  end
end

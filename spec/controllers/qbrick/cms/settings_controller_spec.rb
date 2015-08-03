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
      expect(response.body).to include(I18n.t 'settings.highlighting_font')
    end

    it 'renders default settings' do
      Qbrick::Settings.highlighting_font = 'Comic Sans'
      get :index
      expect(response).to be_success
      expect(response.body).to include(I18n.t 'settings.highlighting_font')
    end
  end

  describe 'POST update' do
    it 'updates settings' do
      Qbrick::Settings.highlighting_font = 'Comic Sans'
      setting = Qbrick::Settings.find_by var: 'highlighting_font'
      post :update, id: setting.id, value: 'Comic Sans Neue'
      expect(response).to be_success
      expect(response.body).to include(I18n.t 'contact_form.personal_fields')
    end
  end
end

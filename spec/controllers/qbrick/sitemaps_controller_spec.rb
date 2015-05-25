require 'spec_helper'

describe Qbrick::SitemapsController, type: :controller do
  routes { Qbrick::Engine.routes }

  describe '#index' do
    it 'should be able to send a xml file' do
      @page = FactoryGirl.create :page
      get :index, format: 'xml'
    end
  end
end

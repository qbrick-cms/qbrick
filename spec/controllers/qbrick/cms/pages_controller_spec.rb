require 'spec_helper'

describe Qbrick::Cms::PagesController, type: :controller do
  routes { Qbrick::Engine.routes }

  describe 'mirroring' do
    around(:each) do |example|
      I18n.with_locale :de do
        example.run
      end
    end

    let(:page) { FactoryGirl.create(:page, path_de: 'de', path_en: 'en') }
    let!(:brick) do
      FactoryGirl.create(:text_brick,
                         brick_list_id: page.id,
                         brick_list_type: 'Qbrick::Page',
                         text: 'DEUTSCH')
    end
    let!(:en_brick) do
      FactoryGirl.create(:text_brick,
                         brick_list_id: page.id,
                         brick_list_type: 'Qbrick::Page',
                         locale: 'en',
                         text: 'ENGLISH')
    end

    before do
      admin = double('admin')
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!) { admin }
      allow(controller).to receive(:current_admin) { admin }
    end

    context 'with no bricks on target locale' do
      it 'clones the existing bricks' do
        xhr :get, :mirror, target_locale: :en, page_id: page.id
        I18n.with_locale :en do
          expect(page.bricks.count).to eq(1)
        end
      end
    end

    context 'with bricks on target locale' do
      it 'does not clone anything without the required parameter' do
        xhr :get, :mirror, target_locale: :en, page_id: page.id
        expect(page.bricks.unscoped.where(locale: :en, brick_list_id: page.id).first.text).to eq('ENGLISH')
      end

      it 'clones the bricks when required parameter is set' do
        expect(page.bricks).to be_any
        xhr :get, :mirror, target_locale: :en, page_id: page.id, rutheless: 'true'
        I18n.with_locale :en do
          expect(Qbrick::Page.find(page.id).bricks.first.text).to eq('DEUTSCH')
        end
      end
    end
  end
end

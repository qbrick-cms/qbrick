require 'spec_helper'

describe Qbrick::PagesController, type: :controller do
  routes { Qbrick::Engine.routes }

  describe '#index' do
    let(:search_term) { 'foobar' }
    let!(:matching) { create(:page, published: 1).tap { |p| p.update_attribute :fulltext, search_term } }
    let!(:nonmatching) { create(:page, published: 1).tap { |p| p.update_attribute :fulltext, 'barfoo' } }
    let!(:unpublished) { create(:page, published: 0).tap { |p| p.update_attribute :fulltext, search_term } }

    context 'with search parameter' do
      it 'assigns the search results' do
        expect(matching.fulltext).to eq search_term
        expect(unpublished.fulltext).to eq search_term

        get :index, search: search_term

        result = assigns :pages
        expect(result).to include matching
        expect(result).not_to include nonmatching
        expect(result).not_to include unpublished
      end
    end
  end

  describe '#show' do
    it "doesn't show unpublished pages" do
      unpublished_page = FactoryGirl.create :page, published: 0
      expect { get :show, url: unpublished_page.slug }.to raise_error(ActionController::RoutingError)
    end

    describe 'routing' do
      context 'on root page' do
        let!(:root_page) { create :root_page }

        context 'with matching locale' do
          it 'loads the page' do
            get :show
            expect(assigns(:page)).to eq(root_page)
          end
        end

        context 'without matching locale' do
          it 'raises a routing error' do
            expect { get(:show, locale: :de) }.to raise_error(ActionController::RoutingError)
          end
        end
      end
    end

    describe 'page type' do
      context 'when page is not a redirect page' do
        it 'responds with page' do
          page = FactoryGirl.create :page, slug: 'dumdidum'
          get :show, url: page.slug
          expect(assigns(:page)).to eq(page)
        end
      end

      context 'when page is a redirect page' do
        it 'redirects to the redirected url' do
          page = FactoryGirl.create :page, page_type: 'redirect', slug: 'dumdidum', redirect_url: '/de/redirect_page'
          get :show, url: page.slug
          expect(response).to redirect_to('/de/redirect_page')
        end

        it 'redirects to invalid redirect urls with too many preceding slashes' do
          page = FactoryGirl.create :page, page_type: 'redirect', slug: 'dumdidum', redirect_url: '///de/redirect_page', published: 1
          get :show, url: page.slug
          expect(response).to redirect_to('/de/redirect_page')
        end

        it 'redirects to root' do
          page = FactoryGirl.create(:page, page_type: 'redirect', slug: 'dumdidum', redirect_url: '/')
          get :show, url: page.slug
          expect(response).to redirect_to('/')
        end
      end
    end
  end
end

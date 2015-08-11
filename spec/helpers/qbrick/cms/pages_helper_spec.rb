require 'spec_helper'

describe Qbrick::Cms::PagesHelper, type: :helper do
  let!(:page) do
    I18n.with_locale(:en) do
      create :page, title: 'Page 1', slug: 'page1', path_de: nil, title_de: nil, slug_de: nil
    end
  end
  before(:each) { @page = page }

  describe '#content_tab_active' do
    it 'returns active when page has a title and no errors' do
      I18n.with_locale :en do
        expect(helper.content_tab_active(@page)).to be(:active)
      end
    end

    it 'returns nil when page has no translation' do
      I18n.with_locale :de do
        expect(helper.content_tab_active(@page)).to be_nil
      end
    end
  end

  describe '#metadata_tab_active' do
    it 'returns active when page is not translated' do
      I18n.with_locale :de do
        expect(helper.metadata_tab_active(@page)).to be(:active)
      end
    end
  end

  describe '#hide_content_tab?' do
    it 'has a page without translations' do
      I18n.with_locale :de do
        expect(helper.hide_content_tab?(@page)).to be_truthy
      end
    end

    it 'has a redirect page' do
      page = create :page, title: 'Redirect', page_type: Qbrick::PageType::REDIRECT, redirect_url: 'en/foo'
      expect(helper.hide_content_tab?(page)).to be_truthy
    end

    it 'has a not saved page' do
      page = Qbrick::Page.new
      expect(helper.hide_content_tab?(page)).to be_truthy
    end
  end
end

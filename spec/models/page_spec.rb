require 'spec_helper'

describe Qbrick::Page, type: :model do
  # subject { described_class }

  describe '.search' do
    before do
      3.times { create :page }
    end

    it 'should find any containing the search term' do
      expect(Qbrick::Page.search('lorem').size).to be >= 0
    end

    it 'should find with "English Title"' do
      expect(Qbrick::Page.search('English Title').size).to be >= 1
    end

    it 'should only find published results' do
      expect(Qbrick::Page.search('English Title')).to be_all { |p| p.published? == true }
    end

    it 'should find by using the old api' do
      expect(Qbrick::Page.search('English')).to eq(Qbrick::Page.search('English'))
    end
  end

  describe '.position_of' do
    it 'should find the position of a page' do
      page = create(:page)
      expect(Qbrick::Page.position_of(page.id)).to eq(page.position)
    end
  end

  describe '.find_by_path' do
    it 'should find its translated content by url' do
      page = create(:page)
      expect(Qbrick::Page.find_by_path(page.path)).to eq(page)
    end
  end

  describe '.flat_tree' do
    it 'should create an ordered, flat list of the page tree' do
      tree = create_page_tree
      expect(Qbrick::Page.flat_tree).to eq(tree)
    end
  end

  describe '#initialize' do
    context 'without values' do
      let :page do
        Qbrick::Page.new
      end

      before do
        page.valid?
      end

      it 'has a mandatory title' do
        expect(page.errors[:title].count).to eq(1)
      end

      it 'has a mandatory slug' do
        expect(page.errors[:slug].count).to eq(1)
      end
    end
  end

  describe '#published' do
    it 'returns only published pages' do
      unpublished_page = 3.times.map { create :page }.last
      unpublished_page.update_attribute :published, Qbrick::PublishState::UNPUBLISHED

      published_pages = Qbrick::Page.published
      expect(published_pages).to be_all { |p| expect(p.published?).to be_truthy }
      expect(published_pages).not_to include unpublished_page
    end
  end

  describe '#content_page' do
    it 'returns only content pages' do
      p1, p2, p3 = 3.times.map { create(:page) }
      p2.update_attribute :page_type, Qbrick::PageType::REDIRECT
      expect(Qbrick::Page.content_page).to eq([p1, p3])
    end
  end

  describe '#state_class' do
    let(:page) { Qbrick::Page.new }

    it 'returns publsihed as string when page is published' do
      page.published = Qbrick::PublishState::PUBLISHED
      expect(page.state_class).to eq 'published'
    end

    it 'returns unpublsihed as string when page is unpublished' do
      page.published = Qbrick::PublishState::UNPUBLISHED
      expect(page.state_class).to eq 'unpublished'
    end
  end

  describe '#without_self' do
    it 'returns pages but not itself' do
      2.times { create(:page) }
      page = Qbrick::Page.first
      expect(page.without_self).not_to include(page)
    end
  end

  describe '#nesting_name' do
    let :page do
      create(:page)
    end

    let :child_page do
      create(:page, parent: page)
    end

    let :child_child_page do
      create(:page, parent: child_page)
    end

    context 'on the topmost level' do
      it 'has a label representing it\'s nesting depth without a leading dash' do
        expect(page.nesting_name).to eq(page.title)
      end
    end

    context 'on the first level' do
      it 'should have a label with one dash' do
        expect(child_page.nesting_name).to eq("- #{child_page.title}")
      end
    end

    context 'on the second level' do
      it 'should have a label with two dashes' do
        expect(child_child_page.nesting_name).to eq("-- #{child_child_page.title}")
      end
    end
  end

  describe '#parent_pages' do
    let :page do
      create(:page)
    end

    let :child_page do
      create(:page, parent: page)
    end

    it 'has a list of parent pages' do
      expect(child_page.parent_pages).to eq([page])
    end

    it 'is ordered from top to bottom' do
      expect(child_page.parent_pages.last).to eq(page)
    end
  end

  describe '#link' do
    context 'when it has no content' do
      it 'should return the link of it\'s first child' do
        page = create(:page)
        child = create(:page, parent: page)
        page.body = nil
        page.save
        expect(page.link).to eq(child.link)
      end
    end
  end

  describe '#increment_position' do
    it 'increments the position by 1' do
      page = create :page
      position = page.position
      page.increment_position
      expect(page.position).to eq(position + 1)
    end
  end

  describe '#decrement_position' do
    it 'decrements the position by 1' do
      page = create :page
      position = page.position
      page.decrement_position
      expect(page.position).to eq(position - 1)
    end
  end

  describe '#preceding_sibling' do
    it 'finds the predecing sibling' do
      _page1 = create :page
      page2 = create :page
      page3 = create :page
      expect(page3.preceding_sibling.id).to eq(page2.id)
    end
  end

  describe '#succeeding_sibling' do
    it 'finds the succeeding sibling' do
      _page1 = create :page
      page2 = create :page
      page3 = create :page
      expect(page2.succeeding_sibling.id).to eq(page3.id)
    end
  end

  describe '#reposition' do
    it 'repositions before a page, specified by id' do
      page1 = create :page
      _page2 = create :page
      page3 = create :page
      page3.reposition page1.id
      expect(page3.preceding_sibling.id).to eq(page1.id)
    end

    it 'repositions before all siblings, specified by nil' do
      _page1 = create :page
      page2 = create :page
      page2.reposition nil
      expect(page2.position).to eq(1)
    end
  end

  describe '#slug' do
    let :page do
      build(:page)
    end

    it 'has a slug by default' do
      page.save
      expect(page.slug).to eq(page.title.parameterize)
    end

    context 'when it is empty' do
      it 'generates the slug' do
        expect(page).to receive(:create_slug)
        page.save
      end
    end

    context 'when it is not empty' do
      it 'takes the slug provided by the user' do
        page.slug = 'my-slug'
        page.save
        expect(page.slug).to eq('my-slug')
      end
    end
  end

  describe '#url' do
    context 'when it is a normal page' do
      it 'returns the concatenated slug of the whole child/parent tree' do
        page = create(:page, slug: 'parent-slug')
        child = create(:page, slug: 'child-slug', parent: page)
        expect(child.path).to eq('/parent-slug/child-slug')
      end
    end

    context 'when it is a navigation? page' do
      it 'returns without the parent page slug' do
        page = create(:page, slug: 'parent-slug', page_type: Qbrick::PageType::NAVIGATION)
        child = create(:page, slug: 'child-slug', parent: page)
        expect(child.path).to eq('/child-slug')
      end
    end

    context 'when it is a redirect? page' do
      it 'returns the absolute url' do
        I18n.with_locale(:en) do
          page = create(:page, page_type: Qbrick::PageType::REDIRECT, redirect_url: 'en/references', slug: 'news')
          expect(page.link).to eq('/en/news')
        end
      end
    end

    context 'when url part is empty' do
      it 'strips the trailing slash' do
        I18n.with_locale(:en) do
          page = create(:page, page_type: Qbrick::PageType::NAVIGATION)
          expect(page.link).to eq('/en')
        end
      end
    end
  end

  describe '#navigation?' do
    context 'when the page_type is navigation' do
      it 'returns true if the page_type is PageType::NAVIGATION' do
        expect(Qbrick::Page.new(page_type: Qbrick::PageType::NAVIGATION).navigation?).to be_truthy
      end
    end

    context 'when the page_type is anything else' do
      it 'returns false' do
        expect(Qbrick::Page.new(page_type: Qbrick::PageType::REDIRECT).navigation?).to be_falsey
      end
    end
  end

  describe '#redirect?' do
    context 'when the page_type is a redirect' do
      it 'returns true' do
        expect(Qbrick::Page.new(page_type: Qbrick::PageType::REDIRECT).redirect?).to be_truthy
      end
    end

    context 'when the page type is anything else' do
      it 'returns false' do
        expect(Qbrick::Page.new(page_type: Qbrick::PageType::NAVIGATION).redirect?).to be_falsey
      end
    end
  end

  describe 'page types' do
    it 'returns content by default' do
      expect(Qbrick::Page.new.page_type).to eq('content')
    end

    it 'returns navigation if set' do
      expect(Qbrick::Page.new(page_type: Qbrick::PageType::NAVIGATION).page_type).to eq('navigation')
    end

    it 'returns redirect if set' do
      expect(Qbrick::Page.new(page_type: Qbrick::PageType::REDIRECT).page_type).to eq('redirect')
    end
  end

  describe '#translated?' do
    it 'returns true when page is translated' do
      page = create(:page, title: 'Page 1', slug: 'page1')
      expect(page.translated?).to be_truthy
    end

    it 'returns false when page has no translation' do
      page = I18n.with_locale(:en) { create :page, title: 'Page 1', slug: 'page1' }
      I18n.with_locale :de do
        expect(page.translated?).to be_falsey
      end
    end
  end

  describe '#fulltext' do
    let :page do
      create(:page, keywords: 'key words', description: 'descrip tion', title: 'my title').tap do |p|
        p.bricks << Qbrick::TextBrick.new(locale: I18n.locale, text: 'oh la la')
        p.save
      end
    end

    context 'when saved' do
      it 'it collects and assigns the fulltext' do
        expect(page).to receive(:collect_fulltext)
        page.save
      end

      it 'contains the page part content' do
        expect(page.fulltext).to include('oh la la')
      end

      it 'converts all data to strings' do
        expect { page.collect_fulltext }.to_not raise_error
      end
    end
  end

  describe '#before_validation' do
    it 'generates path automatically' do
      page = Qbrick::Page.new slug: 'slug'
      expect(page.path).to be_nil
      page.valid?
      expect(page.path).to be_present
    end
  end

  describe '#path' do
    let(:page) { create :page, slug: 'page' }

    context 'without parent' do
      it 'returns path with leading /' do
        expect(page.path).to start_with '/'
      end

      it 'returns a single slug' do
        expect(page.path).to eq('/page')
      end
    end

    context 'when parent is navigation' do
      let :parent do
        create(:page, page_type: Qbrick::PageType::NAVIGATION)
      end

      let :child do
        create(:page, slug: 'child', parent: parent)
      end

      it 'returns path with leading /' do
        expect(child.path).to start_with '/'
      end

      it 'does not concatenate the parent slug' do
        expect(child.path).to eq('/child')
      end
    end

    context 'when parent is normal page' do
      let :parent do
        create(:page, slug: 'parent')
      end

      let :child do
        create(:page, slug: 'child', parent: parent)
      end

      it 'returns path with leading /' do
        expect(child.path).to start_with '/'
      end

      it 'does not concatenate the parent slug' do
        expect(child.path).to eq('/parent/child')
      end
    end
  end

  describe '#translated' do
    before :each do
      I18n.with_locale(:en) do
        @page_1 = create(:page, title: 'Page 1', slug: 'page1')
        @page_2 = create(:page, title: 'Page 2', slug: 'page1')
        @page_3 = create(:page, title: 'Page 3', slug: 'page1')
      end
    end

    it 'returns all pages that have a translation' do
      I18n.with_locale(:en) do
        expect(Qbrick::Page.translated).to eq [@page_1, @page_2, @page_3]
      end
    end

    it 'does not return untranslated pages' do
      I18n.with_locale :de do
        @page_1.update(title: 'Page 1 fr', slug: 'page_1_fr')
        expect(Qbrick::Page.translated).to eq [@page_1]
      end
    end
  end

  describe '#identifier' do
    let(:cat_page) { create :page, identifier: 'cat_content' }

    it 'should check for uniqueness' do
      expect(build(:page, identifier: cat_page.identifier)).to be_invalid
    end

    it 'should be findable via scope' do
      expect(Qbrick::Page.by_identifier(cat_page.identifier)).to eq(cat_page)
    end
  end

  describe '#cloning' do
    around(:each) do |example|
      I18n.with_locale :de do
        example.run
      end
    end

    before do
      @page = create(:page)
    end

    context 'clearing bricks in target locale' do
      it 'does not affect pages other than the target page' do
        another_page = create(:page)
        FactoryGirl.create(:image_brick, brick_list_type: 'Qbrick::Page', brick_list_id: another_page.id)
        expect { @page.clear_bricks_for_locale(:de) }.to_not change { another_page.bricks.count }
      end
    end

    it 'should copy the asset to the cloned brick' do
      FactoryGirl.create(:image_brick, brick_list_type: 'Qbrick::Page', brick_list_id: @page.id)

      @page.clone_bricks_to(:en)
      expect(@page.bricks.unscoped.where(locale: :en).first).to be_valid
    end

    it 'should copy all child bricks' do
      accordion = Qbrick::Brick.create(type: 'Qbrick::AccordionBrick',
                                       brick_list_type: 'Qbrick::Page',
                                       brick_list_id: @page.id)
      section   = Qbrick::Brick.create(type: 'Qbrick::AccordionItemBrick',
                                       caption: 'section',
                                       brick_list_type: 'Qbrick::Brick',
                                       brick_list_id: accordion.id)
      FactoryGirl.create(:text_brick, brick_list_type: 'Qbrick::Brick', brick_list_id: section.id)

      @page.clone_bricks_to(:en)
      expect(@page.bricks.unscoped.where(locale: :en).count).to eq(3)
    end
  end

  describe '#create_path' do
    context 'when parent was saved' do
      it 'updates the child pages url if parent is changed to navigation' do
        parent_page = create :page, slug: 'le_parent'
        child_page = create :page, slug: 'le_child', parent: parent_page
        parent_page.save
        expect(child_page.reload.path).to eq '/le_parent/le_child'

        parent_page.update_attributes page_type: Qbrick::PageType::NAVIGATION
        expect(child_page.reload.path).to eq '/le_child'
      end

      it 'updates the child pages url if parent is changed to content' do
        parent_page = create(:page, slug: 'le_parent', page_type: Qbrick::PageType::NAVIGATION)
        child_page = create(:page, slug: 'le_child', parent: parent_page)

        parent_page.update_attributes(page_type: Qbrick::PageType::CONTENT)
        expect(child_page.reload.path).to eq '/le_parent/le_child'
      end
    end

    it 'creates a root path' do
      root_page = Qbrick::Page.new slug: 'ruth', page_type: Qbrick::PageType::NAVIGATION
      expect(root_page.create_path).to eq ''
    end

    it 'creates a content page path' do
      content_page = Qbrick::Page.new slug: 'meersaeuli', page_type: Qbrick::PageType::CONTENT
      expect(content_page.create_path).to eq '/meersaeuli'
    end

    it 'creates a path with children' do
      parent = create :page, slug: 'le_parent'
      child_page = Qbrick::Page.new slug: 'le_child', parent: parent

      expect(child_page.create_path).to eq '/le_parent/le_child'
    end
  end

  context 'when it is a redirect page' do
    let(:page) { build :page, page_type: Qbrick::PageType::REDIRECT }

    describe '#internal_redirect?' do
      it 'returns false for non redirect pages' do
        expect(build(:page).internal_redirect?).to be_falsey
      end

      it 'returns false for external redirects' do
        page.redirect_url = 'http://google.de'
        expect(page.internal_redirect?).to be_falsey
      end

      it 'returns true for internal redirects' do
        page.redirect_url = '/huhu'
        expect(page.internal_redirect?).to be_truthy
        page.redirect_url = "http://#{Socket.gethostname}/huhu"
        expect(page.internal_redirect?).to be_truthy
      end
    end

    describe '#external_redirect?' do
      it 'returns false for non redirect pages' do
        expect(build(:page).external_redirect?).to be_falsey
      end

      it 'returns true for external redirects' do
        page.redirect_url = 'http://google.de'
        expect(page.external_redirect?).to be_truthy
      end

      it 'returns false for internal redirects' do
        page.redirect_url = '/huhu'
        expect(page.external_redirect?).to be_falsey
        page.redirect_url = "http://#{Socket.gethostname}/huhu"
        expect(page.external_redirect?).to be_falsey
      end
    end
  end
end

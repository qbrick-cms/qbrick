require 'spec_helper'

module Qbrick
  describe Settings, type: :model do
    context 'setting exists' do
      it 'returns the set value' do
        Settings.code = 'SomeValue'
        expect(Settings.code).to eq('SomeValue')
      end

      it 'keeps the value' do
        [42, '23', [3, 4], nil].each do |value|
          Settings.stuff = value
          expect(Settings.stuff).to eq value
        end
      end
    end

    context "setting doesn't exist" do
      it 'returns nil for a call on a non-present setting' do
        expect(Settings.does_not_exist).to be_nil
      end
    end

    context 'on an admin' do
      it 'can be set on an instance' do
        admin = create :admin
        admin.settings.locale = 'cn'
        admin.reload
        expect(admin.settings.locale).to eq 'cn'
      end
    end

    context 'on a brick' do
      it 'can be set on an instance' do
        brick = create :text_brick, brick_list: (Qbrick::Page.first || create(:page))
        brick.settings.color = 'infrared'
        brick.reload
        expect(brick.settings.color).to eq 'infrared'
      end
    end

    context 'on a page' do
      it 'can be set on an instance' do
        page = Qbrick::Page.first || create(:page)
        page.settings.heisen = 'berg'
        page.reload

        expect(page.settings.heisen).to eq 'berg'
      end
    end

    describe '.hierarchy' do
      it 'returns a hierarchy' do
        Qbrick::Settings['global.house.colour'] = 'ultraviolet'
        expected = Qbrick::Settings.find_by var: 'global.house.colour'
        setting = Qbrick::Settings.hierarchy['global']['house']['colour']['_value']

        expect(setting).to eq expected
      end

      it 'returns a hierarchy broken in the end' do
        Qbrick::Settings['global.house.'] = 'ultraviolet'
        expected = Qbrick::Settings.find_by var: 'global.house.'
        setting = Qbrick::Settings.hierarchy['global']['house']['_value']

        expect(setting).to eq expected
      end

      it 'returns a hierarchy broken in the beginning' do
        Qbrick::Settings['.house.colour'] = 'ultraviolet'
        expected = Qbrick::Settings.find_by var: '.house.colour'
        setting = Qbrick::Settings.hierarchy['.house.colour']['_value']

        expect(setting).to eq expected
      end

      it 'returns a hash with overlapping paths' do
        Qbrick::Settings['foo.bar'] = 'far'
        Qbrick::Settings['foo.bar.far'] = 'boo'

        far = Qbrick::Settings.find_by var: 'foo.bar'
        boo = Qbrick::Settings.find_by var: 'foo.bar.far'

        result = Qbrick::Settings.hierarchy['foo']['bar']
        expect(result['_value']).to eq far
        expect(result['far']['_value']).to eq boo
      end
    end
  end
end

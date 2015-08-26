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
  end
end

require 'spec_helper'

module Qbrick
  describe Settings, type: :model do
    describe '[](var)' do
      context 'setting exists' do
        it 'returns the set value' do
          Settings.code = 'SomeValue'
          expect(Settings.code).to eq('SomeValue')
        end

        it 'keeps the value' do
          [42, '23', [3,4], nil].each do |value|
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
    end
  end
end

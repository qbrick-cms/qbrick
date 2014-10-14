require 'spec_helper'

module Qbrick
  describe Setting, type: :model do

    before do
      create(:setting)
      create(:setting, key: 'stuff', value: nil)
    end

    describe '[](key)' do

      context 'setting exists' do
        it 'returns the set value' do
          expect(Setting[:code]).to eq('SomeContent')
        end

        it 'returns empty string for empty setting' do
          expect(Setting[:stuff]).to eq('')
        end
      end

      context "setting doesn't exist" do
        it 'returns empty string for a call on a non-present setting' do
          expect(Setting[:does_not_exist]).to eq('')
        end
      end
    end
  end
end

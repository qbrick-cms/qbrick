require 'spec_helper'

describe Qbrick::BrickTypeFilter, type: :model do
  let :brick_list do
    Qbrick::Page.new
  end

  let :brick_type_filter do
    Qbrick::BrickTypeFilter.new(brick_list)
  end

  describe '#empty?' do
    context 'when the user cant add childs' do
      before do
        allow(brick_list).to receive(:user_can_add_childs?).and_return(false)
      end

      it 'returns true' do
        expect(brick_type_filter.empty?).to be_truthy
      end
    end

    context 'when there are no bricks to be added' do
      before do
        allow(brick_type_filter).to receive(:allowed).and_return([])
      end

      it 'returns true' do
        expect(brick_type_filter.empty?).to be_truthy
      end
    end
  end

  describe '#allowed' do
    context 'when no brick types are registered' do
      it 'returns an empty array' do
        allow(Qbrick::BrickType).to receive_message_chain(:count, :zero?).and_return(true)
        expect(brick_type_filter.allowed).to be_empty
      end
    end

    context 'when brick types are registered' do
      before do
        allow(Qbrick::BrickType).to receive_message_chain(:enabled, :count, :zero?).and_return(false)
      end

      context 'when there are no constraints' do
        it 'returns all enabled brick types' do
          allow(brick_list).to receive(:allowed_brick_types).and_return([])
          expect(Qbrick::BrickType).to receive(:enabled)
          brick_type_filter.allowed
        end
      end

      context 'when there are constraints' do
        it 'constrains the enabled types' do
          allow(brick_list).to receive(:allowed_brick_types).and_return(['Qbrick::TextBrick'])
          expect(Qbrick::BrickType.enabled).to receive(:constrained).with(['Qbrick::TextBrick'])
          brick_type_filter.allowed
        end
      end
    end
  end
end

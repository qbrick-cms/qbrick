require 'spec_helper'

describe Qbrick::PublishState, type: :model do
  context 'unpublished' do
    before do
      @publish_state = Qbrick::PublishState.new(name: 'unpublished', value: Qbrick::PublishState::UNPUBLISHED)
    end

    it 'should be UNPUBLISHED' do
      expect(@publish_state.value).to be(Qbrick::PublishState::UNPUBLISHED)
    end
  end

  context 'published' do
    before do
      @publish_state = Qbrick::PublishState.new(name: 'published', value: Qbrick::PublishState::PUBLISHED)
    end

    it 'should be PUBLISHED' do
      expect(@publish_state.value).to be(Qbrick::PublishState::PUBLISHED)
    end
  end

  context 'published_at' do
    before do
      @publish_state = Qbrick::PublishState.new(name: 'published_at', value: Qbrick::PublishState::PUBLISHED_AT)
    end

    it 'should be PUBLISHED_AT' do
      expect(@publish_state.value).to be(Qbrick::PublishState::PUBLISHED_AT)
    end
  end
end

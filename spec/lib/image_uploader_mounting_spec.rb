require 'spec_helper'

describe Qbrick::ImageUploaderMounting do

  let :brick do
    Qbrick::ImageBrick.new
  end

  describe '#uploader_mounting' do
    it 'has a uploader mounted' do
      expect(brick.class.ancestors.include?(CarrierWave::Mount::Extension)).to be_truthy
    end
  end
end

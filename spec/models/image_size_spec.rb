require 'spec_helper'

describe Qbrick::ImageSize, type: :model do
  before do
    Qbrick::ImageSize.build_defaults!
  end

  describe '.build_defaults!' do
    it 'sets the default sizes' do
      expect(Qbrick::ImageSize.all).to eq([Qbrick::ImageSize.gallery_size,
                                            Qbrick::ImageSize.teaser_size])
    end
  end

  describe '.clear!' do
    before do
      Qbrick::ImageSize.clear!
    end

    it 'empties the list' do
      expect(Qbrick::ImageSize.all).to be_empty
    end
  end

  describe '.add' do
    it 'adds a new image size' do
      expect { Qbrick::ImageSize.add(:stuff, 200, 100) }.to change(Qbrick::ImageSize.all, :count).by(1)
    end
  end

  describe '.find_by_name' do
    it 'returns the size' do
      expect(Qbrick::ImageSize.find_by_name('gallery')).to eq(Qbrick::ImageSize.gallery_size)
    end
  end
end

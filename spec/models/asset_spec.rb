require 'spec_helper'

describe Qbrick::Asset, type: :model do
  let :asset do
    create(:asset)
  end

  let :uploader do
    u = Qbrick::AssetUploader.new(asset, :file)
    u.store! File.open(Qbrick::Engine.root.join('spec/dummy/app/assets/images/spec-image.png'))
    u
  end

  before do
    Qbrick::AssetUploader.enable_processing = true
  end

  after do
    Qbrick::AssetUploader.enable_processing = false
  end

  it 'has a thumbnail' do
    expect(uploader).to respond_to(:thumb)
  end

  it 'makes the image readable only to the owner and not executable' do
    expect(uploader.permissions).to eq(0600)
  end

  describe '#file_type' do
    it 'has a file_type' do
      expect(asset).to respond_to(:file_type)
    end

    it 'is symbolized' do
      expect(asset.file_type).to be_a(Symbol)
    end
  end
end

class AddGoogleVerificationKeyToQbrickPages < ActiveRecord::Migration
  def change
    add_column :qbrick_pages, :google_verification_key, :string
  end
end

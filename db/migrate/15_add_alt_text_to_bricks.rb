class AddAltTextToBricks < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :alt_text, :string
  end
end

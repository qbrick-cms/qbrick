class AddDisplayStylesToBricks < ActiveRecord::Migration
  def change
    add_column :qbrick_bricks, :display_styles, :text
  end
end

class AddTemplateNameToQbrickBricks < ActiveRecord::Migration
  def change
    change_table :qbrick_bricks do |t|
      t.string :template_name
    end
  end
end

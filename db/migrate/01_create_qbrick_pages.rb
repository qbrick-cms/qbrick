class CreateQbrickPages < ActiveRecord::Migration

  def change
    create_table :qbrick_pages do |t|
      t.integer :position
      t.string :title_en
      t.string :title_de
      t.string :slug_en
      t.string :slug_de
      t.string :keywords_en
      t.string :keywords_de
      t.text :description_en
      t.text :description_de
      t.text :body_en
      t.text :body_de
      t.integer :published
      t.references :page
      t.text :url_en
      t.text :url_de
      t.string :page_type
      t.text :fulltext_en
      t.text :fulltext_de
      t.string :ancestry
      t.timestamps
    end

    add_index :qbrick_pages, :ancestry
    add_index :qbrick_pages, :published
  end

end

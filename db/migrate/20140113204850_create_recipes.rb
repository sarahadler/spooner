class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :spoon_id
      t.text :post_content
      t.string :title
      t.string :url
      t.string :post_type

      t.timestamps
    end
  end
end

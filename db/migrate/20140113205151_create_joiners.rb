class CreateJoiners < ActiveRecord::Migration
  def change
    create_table :joiners do |t|
      t.integer :recipe_id
      t.integer :photo_id
      t.integer :recipe_spoon_id
      t.integer :photo_spoon_id

      t.timestamps
    end
  end
end

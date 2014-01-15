class RemoveSpoonIdsFromJoiner < ActiveRecord::Migration
  def up
  	remove_column :joiners, :recipe_spoon_id
  	remove_column :joiners, :photo_spoon_id
  end

  def down
  	add_column :joiners, :recipe_spoon_id, :integer
  	add_column :joiners, :photo_spoon_id, :integer
  end
end

class Joiner < ActiveRecord::Base
  attr_accessible :photo_id, :photo_spoon_id, :recipe_id, :recipe_spoon_id, :recipe, :photo
  belongs_to :recipe
  belongs_to :photo
end

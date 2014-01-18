class Like < ActiveRecord::Base
  attr_accessible :recipe_id, :user_id
  belongs_to :recipe
  belongs_to :user
end

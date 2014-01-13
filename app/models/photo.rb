class Photo < ActiveRecord::Base
  attr_accessible :spoon_id, :url
  has_many :joiners
  has_many :recipes, through: :joiners
end

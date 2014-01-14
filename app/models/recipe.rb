class Recipe < ActiveRecord::Base
  attr_accessible :post_content, :post_type, :spoon_id, :title, :url, :ingredients
  has_many :joiners
  has_many :photos, through: :joiners

  def list_ingredients
  	ingredients = self.ingredients.split(/\n|\r\n/)
  	ingredients.shift
  	ingredients.pop
  	ingredients
  end

end

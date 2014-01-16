class Recipe < ActiveRecord::Base
  attr_accessible :post_content, :post_type, :spoon_id, :title, :url, :ingredients
  has_many :joiners
  has_many :photos, through: :joiners

  has_many :likes
  has_many :likers, :through => :likes, :source => :user 

  def list_ingredients
    if self.ingredients
    	ingredients = self.ingredients.split(/\n|\r\n/)
    	ingredients.shift
    	ingredients.pop
    	ingredients
    else
      []
    end
  end

  def self.search_and(query)
    regex = query.map { |query| Regexp.new(query, 'i') } 
    @found = {}
    regex.each do |regex|
      @found[regex.to_s.to_sym] = []
      all.each do |recipe| 
        if recipe[:ingredients] =~ regex
          @found[regex.to_s.to_sym] << recipe
        end
      end
    end
    @recipes = @found.values.first
    @found.values.each do |array| 
      @recipes = @recipes & array
    end
    return @recipes
  end

  def self.search_or(query)
    query = query.join('|')
    regex = Regexp.new(query, 'i')

    @recipes = []
    all.each do |recipe|
      if recipe[:ingredients] =~ regex
        @recipes << recipe
      end
    end
    return @recipes
  end

  def liked_by
    self.likers.map do |liker|
      liker.name
    end
  end

  def liked_by_photos
    self.likers.map do |liker|
      liker.image
    end
  end

end

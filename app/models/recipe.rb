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

  def self.search_all(query)
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
    @all = @found.values.first
    @found.values.each do |array| 
      @all = @all & array
    end
    return @all
  end

  def self.search_any(query)
    query = query.join('|')
    regex = Regexp.new(query, 'i')

    any = []
    all.each do |recipe|
      if recipe[:ingredients] =~ regex
        any << recipe
      end
    end
    return any
  end

  def self.make_searchable(params)
    if params.match(/,| and | or /)
      array = params.split(/,| and | or |&/i)
    else
      array = params.split(/ and | or |&|\s/i)
    end
    array.delete('')
    array.delete('and')
    array.delete('or')
    array.delete('&')
    query = array.map do |query| 
      query.strip.chomp('s')
    end
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

  # def split_into_links 
  #   array = self.title.split
  #   with_links = array.each do |word|
  #     unless word == 'of' || word == 'all' || word == 'the' || word == 'simple' || word == 'from'
  #       with_link = "<a href='/recipes/search/any?ingredients=#{word}'>word</a>"
  #       array.gsub(word, with_link)
  #     end
  #   end
  #   with_links.join(' ')
  # end

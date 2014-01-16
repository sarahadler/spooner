require 'csv'

@data = []
CSV.foreach('./wp_posts.csv') do |row|
	new_el = {}
	new_el[:post_id] = row[0]
	new_el[:post_content] = row[4]
	new_el[:title] = row[5]
	new_el[:url] = row[18]
	new_el[:post_type] = row[20]
	@data << new_el
end

@recipes = []


######################################################### PULL OUT RECIPES
@data.each do |hash|
	if hash[:post_type] == 'recipe' || hash[:post_type] == 'recipes'
		@recipes << hash
	end
end

@ingredients = {}
######################################################### SPLIT POST INTO SECTIONS

@recipes.each do |recipe|
	sections = recipe[:post_content].split(/(Ingredients|Directions|caption|Instructions|What you need:|How to do it:|What to do:)/)
	@ingredients[recipe[:post_id]] = []
	sections.each do |section|
		@ingredients[recipe[:post_id]] << section
	end
end

######################################################### PICK INGREDIENT SECTION(S)
@one = {}
@zero = {}
@more = {}
@missing = {}


@ingredients.each do | id, array |
  array.each do |section|
		if section.length > 50
		end
	end
	array.keep_if do |section|
		section.scan(/(cup|\/|spoon|shot|oz\s|¼|½|ounces|,\s\S*ed)/i).any?
	end
	array.uniq
	if array.count > 1
		array.keep_if do |section|
			section.scan(/(Prepare|<\/?li>|Slice\s|spoonuniversity|Now\s|attachment|Crumble\s|Cut\s|Heat\s|Bake\s|In\sa\s\S*\sbowl|Photo by \S*\s\S*|Refrigerate|Mix|combine|Photo|Total Time|Prep Time|Despite|°|Microwave|preheat|Drain|When|This|Add|Preheat|Pre-heat|pre-heat|Place|Combine)/).empty?
		end
		array.uniq
	end
	if array.count == 0
		@zero[id] = []
		@zero[id] << array
		@missing[id] = []
		@missing[id] << id
	elsif array.count == 1
		@one[id] = []
		@one[id] << array
	else
		@more[id] = []
		@more[id] << array
	end
end

######################################################### TURN INTO ACCEPTABLE STRINGS

@ingredients.each do | k , v |
	v.uniq
	v = v.join
	v = v.gsub(/(<\/?strong>|<\/?b>|<\/?em>)/,'')
	@ingredients[k] = v
end




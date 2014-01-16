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
	sections = recipe[:post_content].split(/ingredients|directions/i)
	@ingredients[recipe[:post_id]] = []
	sections.each do |section|
		@ingredients[recipe[:post_id]] << section
	end
end

######################################################### PICK INGREDIENT SECTION(S)

@ingredients.values.each do |array_of_sections|
  array_of_sections.keep_if do |section|
		section.length > 50
	end
	array_of_sections.keep_if do |section_of_content|
		section_of_content.scan(/(cup|\/|spoon|shot|oz\s|¼|½|ounces|,\s\S*ed)/i).any?
	end
	array_of_sections.uniq
	if array_of_sections.count > 1
		array_of_sections.keep_if do |section_of_content|
			section_of_content.scan(/(Prepare|<\/?li>|Crumble|Bake|Refrigerate|Mix|combine|Total Time|Prep Time|Despite|Photo|°|Microwave|preheat|Drain|When|This|The|Add|Preheat|Pre-heat|pre-heat|Place|Combine|\?)/).empty?
		end
		array_of_sections.uniq
	end
end

######################################################### TURN INTO ACCEPTABLE STRINGS

@ingredients.each do | k , v |
	v.uniq
	v = v.join
	v = v.gsub(/(<\/?strong>|<\/?b>|<\/?em>)/,'')
	@ingredients[k] = v
end




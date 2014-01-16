# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



  # `psql spooner_app_development < database.sql`
  # `psql spooner_app_test < database.sql`

require "csv"
require "pry"



##################################################### PARSE DATA


@data = []
CSV.foreach( Rails.root.join('lib','data','wp_posts.csv')) do |row|
	new_el = {}
	new_el[:post_id] = row[0]
	new_el[:post_content] = row[4]
	new_el[:title] = row[5]
	new_el[:url] = row[18]
	new_el[:post_type] = row[20]
	@data << new_el
end

###################################################### GET JOIN TABLE

@post_meta = []
CSV.foreach( Rails.root.join('_test_data','wp_postmeta.csv')) do |row|
	new_el = {}
	new_el[:meta_id] = row[0]
	new_el[:post_id] = row[1]
	new_el[:meta_key] = row[2]
	new_el[:meta_value] = row[3]
	@post_meta << new_el
end

@post_meta.keep_if {|x| x[:meta_key] == '_thumbnail_id'}


# ###################################################### PULL OUT RECIPES
@ingredients = {}

@data.each do |entry| 
	if entry[:post_type] == 'recipe' || entry[:post_type] == 'recipes' 

############### FIX URLs
		entry[:title] = entry[:title].gsub('&amp;','&')
		entry[:url] = entry[:url].sub(/\d{4}\/\d{,2}\/\d{,2}/, 'recipe')
		entry[:url] = entry[:url].sub(/food-thought\//,'')
		entry[:url] = entry[:url].sub(/\?post_type=recipe.*;/,'recipe/?')
		if entry[:url].include?('recipe') == false
			entry[:url] = entry[:url].gsub('.com/', '.com/recipe/')
		end

# ###################################################### CREATE

		sections = entry[:post_content].split(/ingredients|directions/i)
		@ingredients[entry[:post_id]] = []
		sections.each do |section|
			@ingredients[entry[:post_id]] << section
		end 


		Recipe.create({
			spoon_id: entry[:post_id],
			post_content: entry[:post_content],
			title: entry[:title],
			url: entry[:url],
			ingredients: 'ingredients'
		})

###################################################### PULL OUT ATTACHMENTS

	elsif entry[:post_type] == 'attachment' 
		
		Photo.create({
			spoon_id: entry[:post_id],
			url: entry[:url],
		})

	end
end

################  PICK INGREDIENT SECTION(S)

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

################   TURN INTO ACCEPTABLE STRINGS

@ingredients.each do | k , v |
	v.uniq
	v = v.join
	v = v.gsub(/(<\/?strong>|<\/?b>|<\/?em>)/,'')
	@ingredients[k] = v
end


###################################################### CHANGE INGREDIENTS

@ingredients.each do | k, v |
	recipe = Recipe.find_by_spoon_id(k)
	recipe.ingredients = v
	recipe.save
end

###################################################### JOINER TABLE

@post_meta.each do |entry|
	if Recipe.find_by_spoon_id(entry[:post_id])
		Joiner.create({
			recipe_id: Recipe.find_by_spoon_id(entry[:post_id]).id,
			photo_id: Photo.find_by_spoon_id(entry[:meta_value]).id
			})
	end
end







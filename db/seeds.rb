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

@data.each do |entry| 
	if entry[:post_type] == 'recipe' || entry[:post_type] == 'recipes' 

############### FIX URLs
		entry[:title] = entry[:title].gsub('&amp;','&')
		entry[:url] = entry[:url].gsub(/\d{4}\/\d{,2}\/\d{,2}/, 'recipe')
		if entry[:url].include?('recipe') == false
			entry[:url] = entry[:url].gsub('.com/', '.com/recipe/')
		end

############## ADD INGREDIENTS TO RECIPE HASH -------------- this is flawed
	
		entry[:ingredients] = entry[:post_content].split(/(Ingredients|Directions)/)[2]
		

		Recipe.create({
			spoon_id: entry[:post_id],
			post_content: entry[:post_content],
			title: entry[:title],
			url: entry[:url],
			ingredients: entry[:ingredients]
		})

###################################################### PULL OUT ATTACHMENTS

	elsif entry[:post_type] == 'attachment' 
		
		Photo.create({
			spoon_id: entry[:post_id],
			url: entry[:url],
		})

	end
end

###################################################### ADD JOINER/ ASSOC TABLES

@post_meta.each do |entry|
	if Recipe.find_by_spoon_id(entry[:post_id])
		Joiner.create({
			recipe_id: Recipe.find_by_spoon_id(entry[:post_id]).id,
			photo_id: Photo.find_by_spoon_id(entry[:meta_value]).id
			})
	end
end







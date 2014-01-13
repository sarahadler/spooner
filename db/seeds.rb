# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require "CSV"

###################################################### PARSE DATA

# @data = []
# CSV.foreach(Rails.root + 'lib/data/wp_posts.csv') do |row|
# 	new_el = {}
# 	new_el[:post_id] = row[0]
# 	new_el[:post_content] = row[4]
# 	new_el[:title] = row[5]
# 	new_el[:url] = row[18]
# 	new_el[:post_type] = row[20]
# 	@data << new_el
# end

# ###################################################### GET JOIN TABLE

@post_meta = []
CSV.foreach(Rails.root + 'lib/data/wp_post_meta.csv') do |row|
	new_el = {}
	new_el[:meta_id] = row[0]
	new_el[:post_id] = row[1].to_i
	new_el[:meta_key] = row[2]
	new_el[:meta_value] = row[3].to_i
	@post_meta << new_el
end

@post_meta.keep_if {|x| x[:meta_key] == '_thumbnail_id'}


###################################################### PULL OUT RECIPES & ATTACHMENTS


@data.each do |entry| 
	if entry[:post_type] == 'recipe' || entry[:post_type] == 'recipes' 
		Recipe.create({
			spoon_id: entry[:post_id].to_i,
			post_content: entry[:post_content],
			title: entry[:title],
			url: entry[:url],
			post_type: entry[:post_type],
			ingredients: entry[:post_content].split(/(Ingredients|Directions)/)[2]
			})
	elsif entry[:post_type] == 'attachment' 
		Photo.create({
			spoon_id: entry[:post_id].to_i,
			url: entry[:url]
			})
	end
end


@post_meta.each do |entry|
	if Recipe.find_by_spoon_id(entry[:post_id])
		Joiner.create({
			recipe_id: Recipe.find_by_spoon_id(entry[:post_id]).id,
			photo_id: Photo.find_by_spoon_id(entry[:meta_value]).id
			})
	end
end



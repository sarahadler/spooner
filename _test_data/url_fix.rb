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
@photos = []
@other = []

@data.each do |hash|
	if hash[:post_type] == 'recipe' || hash[:post_type] == 'recipes'
		@recipes << hash
	elsif hash[:post_type] == 'attachment'
		@photos << hash
	else
		@other << hash
	end
end



@pulled_out = []

@posts = @recipes.map do |recipe|
	if recipe[:url].include?('?post_type=')
		recipe[:url] = recipe[:url].sub(/\?post_type=recipe.*;/,'recipe/?')
		@pulled_out << recipe[:url]
	end
	recipe[:url]
end

@images = @photos.map do |photo|
	photo[:url]
end


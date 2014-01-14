require "CSV"
require "pry"


###################################################### PARSE DATA

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

###################################################### GET JOIN TABLE

@post_meta = []
CSV.foreach('./wp_post_meta.csv') do |row|
	new_el = {}
	new_el[:meta_id] = row[0]
	new_el[:post_id] = row[1]
	new_el[:meta_key] = row[2]
	new_el[:meta_value] = row[3]
	@post_meta << new_el
end

@post_meta.keep_if {|x| x[:meta_key] == '_thumbnail_id'}


###################################################### PULL OUT RECIPES & ATTACHMENTS

@recipes = []
@attachments = []

@data.each do |entry| 
	if entry[:post_type] == 'recipe' || entry[:post_type] == 'recipes' 
		entry[:url] = entry[:url].gsub(/\d{4}\/\d{,2}\/\d{,2}/, 'recipe')
		@recipes << entry
	elsif entry[:post_type] == 'attachment' 
		@attachments << entry
	end
end

###################################################### ADD INGREDIENTS TO RECIPE HASH

@recipes.each do |recipe|
	recipe[:ingredients] = recipe[:post_content].split(/(Ingredients|Directions)/)[2]
end

###################################################### GET USER INPUT TO CREATE REGEX


puts "what do you want to search for?"

############### FOR 'OR'
#answer = gets.chomp.split.join(' | ')
#@selection = Regexp.new(answer, 'i')


############### FOR 'AND'
answer = gets.chomp.split(', ')
@regex = answer.map { |answer| Regexp.new(answer, 'i') }
 

###################################################### CREATE HASH OF FOUND ARRAYS


@found = {}

	@regex.each do |regex|
		@found[regex.to_s.to_sym] = []
		@recipes.each do |recipe| 
			if recipe[:ingredients] =~ regex
				@found[regex.to_s.to_sym] << recipe
			end
		end
	end

###################################################### FIND COMMON ELEMENTS

if @regex.count > 1

	unless @found.values.first.empty?
	@common = @found.values.first

		@found.values.each do |array| 
			@common = @common & array
		end

	end
end

###################################################### ASSOC WITH IMAGES

@complete = []

if @found.values.first.empty?
	puts "Sorry, but there's nothing with that in it!"
else
	@post_meta.each do |entry|
		@common.each do |recipe|
			if entry[:post_id] == recipe[:post_id]
				@attachments.each do |attachment|
					if attachment[:post_id] == entry[:meta_value]
						hash = {}
						hash[:title] = recipe[:title]
						hash[:url] = recipe[:url]
						hash[:content] = recipe[:post_content]
						hash[:photo] = attachment[:url]
						hash[:ingredients] = recipe[:ingredients]
						@complete << hash
					end
				end
			end
		end
	end
end












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

@data.each do |hash|
	if hash[:post_type] == 'recipe' || hash[:post_type] == 'recipes'
		@recipes << hash
	end
end

@discard = []
@ingredients = {}


@recipes.each do |recipe|
sections = recipe[:post_content].split(/ingredients|directions/i)
@ingredients[recipe[:post_id]] = []

  ################################################ LOOP THROUGH SECTIONS
#   sections.each do |section|
# 	  if section.scan(/(combine|can't|place| is |pre-heat| \? | so |lying|indulge|that's|rinse|minutes|night|week|bring| no |boil| too | don't| be |time|preheat|reason|until|it's|°| gets |image|photo)/i).empty? == false
# 	  	@discard << section
# 	  	sections.delete(section)
# 	  end
# 	end
# 	sections.keep_if do |section|
# 		section.length > 50
# 		@discard << section
# 	end
# 	sections.each do |section|
#   	if section.include?('.') == false
#   		@ingredients[recipe[:post_id]] << section
#   	elsif section.scan(/(spoon|cup|box|oz|shot)/i)
# 			@ingredients[recipe[:post_id]] << section
#   	end
# 	end
# end

# @to_table = @ingredients.values.map do |array|
# 	array.join
# end

  sections.keep_if do |section|
		section.length > 50
	end
	sections.each do |section|
  	if section.include?('.') == false
  		@ingredients[recipe[:post_id]] << section
  	end
	  if section.scan(/(combine|day|can't|place| is |pre-heat|\?|\.| so |lying|indulge|that's|rinse|minutes|night|week|bring| no |boil| too | don't| be |time|preheat|reason|until|it's|°| gets |image|photo)/i).empty? == false
	  	@discard << section
	  	sections.delete(section)
	  end
	  if section.scan(/(spoon|cup|box|oz|shot)/i)
  		@ingredients[recipe[:post_id]] << section
  	end
	end

end


@zero = []
@one = []
@more = []
@before_unique = []

@ingredients.values.each do |list|
	if list.count == 0
		@zero << list
	elsif list.count == 1
		@one << list
	else
		list.each do |section|
			if section.scan(/(combine|can't|place| is |pre-heat|\?| so |lying|indulge|that's|rinse|minutes|night|week|bring| no |boil| too | don't| be |time|preheat|reason|until|it's|°| gets |image|photo)/i).empty? == false
		  	@discard << section
		  	list.delete(section)
		  end
		end
		#list.keep_if do |string|
		#	string.scan((/Photo/)).empty?
		#end 
		@before_unique << list
		list.uniq
		if list.count == 0
			@zero << list
		elsif list.count == 1
			@one << list
		else
		@more << list
		end
	end
end





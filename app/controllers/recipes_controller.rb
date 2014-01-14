class RecipesController < ApplicationController
  before_filter :authenticate_user!

 #        root        /                              recipes#search
 	def search
 		
 	end
# 			recipes GET   /recipes(.:format)             recipes#index
  def index
	 	if params[:ingredients] && params[:how]
	 		
	 		####  MAKE PARAMS USABLE

	 		@ingredients = params[:ingredients]
	 		array = @ingredients.split(/,|and|&/)
		 	answer = array.map {|answer| answer.strip}
		
			####  IF FILTERING BY 'AND'
	 		if params[:how] == "and"
				regex = answer.map { |answer| Regexp.new(answer, 'i') }	
				@found = {}
					regex.each do |regex|
						@found[regex.to_s.to_sym] = []
						Recipe.all.each do |recipe| 
							if recipe[:ingredients] =~ regex
								@found[regex.to_s.to_sym] << recipe
							end
						end
					end
				@common = @found.values.first
					@found.values.each do |array| 
						@common = @common & array
					end

			####  IF FILTERING BY 'OR'

			elsif params[:how] == "or"
				answer = answer.join('|')
				regex = Regexp.new(answer, 'i')
				
				@common = []
				Recipe.all.each do |recipe|
					if recipe[:ingredients] =~ regex
						@common << recipe
					end
				end
			end

			####  RETURN RESULTS

			@common
			@ingredients = array.join(' and ')
	 	else
	 		redirect_to root_path
	 	end

 end
 # edit_recipe GET    /recipes/:id/edit(.:format)    recipes#edit
 #      recipe GET    /recipes/:id(.:format)         recipes#show
 def show 
 	@recipe = Recipe.find(params[:id])
 end
 #             PUT    /recipes/:id(.:format)         recipes#update
 #             DELETE /recipes/:id(.:format)         recipes#destroy	

end












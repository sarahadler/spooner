class RecipesController < ApplicationController
  
  before_filter :authenticate_user!


 #        root        /                              recipes#search
 	def search
 		
 	end
 #     recipes GET    /recipes(.:format)             recipes#index
 def index
 	if params[:ingredients]
 		@ingredients = params[:ingredients]
 		answer = @ingredients.split(', ')
		regex = answer.map { |answer| Regexp.new(answer, 'i') }

		@found = {}
		####  CREATE ARRAYS FOR EACH INGREDIENT REQUIREMENT
			regex.each do |regex|
				@found[regex.to_s.to_sym] = []
				Recipe.all.each do |recipe| 
					if recipe[:ingredients] =~ regex
						@found[regex.to_s.to_sym] << recipe
					end
				end
			end


		####  FIND COMMON ELEMENTS

		unless @found.values.first.empty?
		@common = @found.values.first
			@found.values.each do |array| 
				@common = @common & array
			end
		end
		

		@common
		@ingredients
 	else
 		redirect_to '/'
 	end
 end
 # edit_recipe GET    /recipes/:id/edit(.:format)    recipes#edit
 #      recipe GET    /recipes/:id(.:format)         recipes#show
 #             PUT    /recipes/:id(.:format)         recipes#update
 #             DELETE /recipes/:id(.:format)         recipes#destroy	

end












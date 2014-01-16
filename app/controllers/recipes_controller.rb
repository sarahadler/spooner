class RecipesController < ApplicationController

 #        root        /                              recipes#search
 def search

 end
# 			recipes GET   /recipes(.:format)             recipes#index
def index
	if params[:ingredients] && params[:how]

		 		##########################################  MAKE PARAMS USABLE
		 		ingredients = params[:ingredients]
		 		array = ingredients.split(/,|and|&/)
		 		query = array.map {|query| query.strip}

				######################################  IF FILTERING BY 'AND'
				if params[:how] == "and"

					@recipes = Recipe.search_and(query)

				#####################################  IF FILTERING BY 'OR'

			elsif params[:how] == "or"

				@recipes = Recipe.search_or(query)
				
			end
			
			#######################  also return ingredients	

			@ingredients = array.join(' and ')

		else
			redirect_to root_path
		end
	end

 #      recipe GET    /recipes/:id(.:format)         recipes#show
def show 
	@recipe = Recipe.find(params[:id])
 	@random = Recipe.all.shuffle.first
end

 #    GET      /recipes/:id/like(.:format)            recipes#like
 def like 
 	@recipe = Recipe.find(params[:id])
 	current_user.faves << @recipe
 	@random = Recipe.all.shuffle.first
 	redirect_to recipe_path(@recipe)
 end

 #    GET      /recipes/:id/unlike(.:format)          recipes#unlike
 def unlike
 	@recipe = Recipe.find(params[:id])
 	current_user.faves.delete(@recipe)
 	@random = Recipe.first(:offset => rand(Recipe.count)).id
 	redirect_to recipe_path(@recipe)
 end

#  GET      /recipes/:id/later(.:format)           recipes#later
	def later 
		@recipes = current_user.faves
	end
#   oops GET      /oops(.:format)                        recipes#oops
	def oops
		
	end

end












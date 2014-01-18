class RecipesController < ApplicationController

 #        root        /                              recipes#search
 	def search
 		
 	end
# 			recipes GET   /recipes(.:format)             recipes#index
  def index
	 	if params[:ingredients]
	 		
	 		####  MAKE PARAMS USABLE



			####  RETURN RESULTS

			@or
			@and
			binding.pry
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












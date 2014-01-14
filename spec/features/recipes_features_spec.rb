require 'spec_helper'


describe "searching for ingredients" do 
	describe "starting on the search form" do 
		before do 
			visit root_path
			login_as(@user)
		end
		it "should take input from the user." do
			fill_in 'ingredients', {with: 'Butternut Squash'}
			click_button 'submit'

			current_path.should == recipes_path
			page.should have_content('Butternut Squash')
		end
	end
end

describe "looking at a recipe" do
	describe "on a show page" do
		before do 
			id = Recipe.all.first.id 
			visit recipe_path(id)
			login_as(@user)
		end
		it "should show that recipe's information" do
			page.should have_content(Recipe.all.first.title)
		end
	end
end
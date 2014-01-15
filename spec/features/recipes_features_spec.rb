require 'spec_helper'

describe "searching for ingredients" do 
	describe "starting on the search form" do 
		before do 
			visit root_path
		end
		it "should take input from the user." do
			fill_in 'ingredients', {with: 'Butternut Squash'}
			click_button 'submit'

			current_path.should == recipes_path
			page.should have_content('Butternut Squash')
		end
	end
end
describe "when a user tries to log in" do
	before do
		@user = User.create({
			email: 'sarah.e.adler@gmail.com',
			name: 'Sarah Adler',
			password: 'northwestern'
			})
		login_as(@user)
	end
	it "should see their personal options" do 
		visit root_path
		page.should have_content('Sarah Adler')
	end
	describe "it should be able to view favorites" do
		before do
			visit root_path
			click_link 'saved'
		end
		it "should show favorites" do
			page.should have_content('Saved for Later')
		end
	end
	describe "on a recipe page" do
		before do 
			id = Recipe.first.id 
			visit recipe_path(id)
		end
		it "should be able to like the recipe" do 
			click_link "like"
			@user.faves.should include Recipe.first
			page.should have_content @user.name
		end
		describe "and after it refreshes" do 
			before do
			id = Recipe.first.id 
			visit recipe_path(id)
			end
			it "should be able to unlike it." do 
				click_link "like"
				@user.faves.should_not include Recipe.first
			end
		end
	end
end
describe "looking at a recipe" do
	describe "on a show page" do
		before do 
			id = Recipe.first.id 
			visit recipe_path(id)
		end
		it "should show that recipe's information" do
			page.should have_content(Recipe.first.title)
		end
	end
end

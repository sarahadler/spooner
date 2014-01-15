require 'spec_helper'

describe RecipesController do 
	describe "given search parameters" do
		before do 
			@and = {
				ingredients: "milk, eggs",
				how: "and"
			}
			@or = {
				ingredients: "milk, eggs",
				how: "or"
			}
		end
		describe "when visiting the results page with 'and'" do 
			before do 
				get :index, @and
			end
			it "retrieves all results for 'and'" do
				assigns(:recipes).count.should == 18
			end
		end
		describe "when visiting the results page with 'or'" do 
			before do 
				get :index, @or
			end
			it "retrieves all results for 'or'" do
				assigns(:recipes).count.should == 113
			end
		end
	end
end
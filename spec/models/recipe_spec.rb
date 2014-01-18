require 'spec_helper'

describe Recipe do
	describe "if trying to do a search" do 

		describe "given parameter 'and'" do
			before do
				@query = ['eggs', 'milk']
			end
			it "should return results for 'and'" do 
				result = Recipe.search_and(@query)
				result.should include Recipe.find_by_title("Maple Browned Butter Bacon Cupcakes")
				result.should_not include Recipe.find_by_title("Roasted Brussels Sprouts with Bacon")
				result.count.should == 18
			end
			before do
				@query = ['milk', 'eggs']
			end
			it "should return results for 'and'" do 
				result = Recipe.search_and(@query)
				result.should include Recipe.find_by_title("Maple Browned Butter Bacon Cupcakes")
				result.should_not include Recipe.find_by_title("Roasted Brussels Sprouts with Bacon")
				result.count.should == 18
			end
		end

		describe "given parameter 'or'" do
			before do
				@query = ['eggs', 'milk']
			end
			it "should return results for 'or'" do 
				result = Recipe.search_or(@query)
				result.should include Recipe.find_by_title("Dillo Weekend: Margarita Bars")
				result.should_not include Recipe.find_by_title("Roasted Brussels Sprouts with Bacon")
				result.count.should == 113
			end
		end

	end
end

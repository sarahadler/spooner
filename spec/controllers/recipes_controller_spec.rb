require 'spec_helper'

describe RecipesController do 
	describe "if given search input for 'or' " do
		before do
			get :index, {
				how: 'or',
				ingredients: 'macaroni and cheese'
			}
		end

		it "should translate the params into useful info" do 
			@regex.should == Regex.new('macaroni|cheese', 'i')
		end
	end

end
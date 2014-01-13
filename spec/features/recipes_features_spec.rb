require 'spec_helper'


describe "searching for ingredients" do 
	describe "starting on the search form" do 
		before do 
			visit '/'
		end
		it "should take input from the user." do
			fill_in 'ingredients', {with: 'Butternut Squash'}
			click_button 'submit'

			current_path.should == '/recipes/'
			page.should have_content('Butternut Squash')
		end
	end
end
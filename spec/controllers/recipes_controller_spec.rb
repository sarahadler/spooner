require 'spec_helper'

describe RecipesController do 
  describe "if a user is signed in"
  before do
    sign_in @user
  end
    describe "and on a recipe's show page"
    before do 
      visit
    end 

end
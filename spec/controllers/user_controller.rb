require 'spec_helper'

describe UserController do
  describe "if a user logs in"
  before do
		@request.env["devise.mapping"] = Devise.mappings[:user]
		get :new
  	@user = User.create({
  		email: 'sarah.e.adler@gmail.com',
  		password: 'northwestern'
  		})
    sign_in @user
  end
  it "should be logged in" do
  	@user.should != nil
  end	
end
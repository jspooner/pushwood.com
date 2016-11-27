require 'spec_helper'

describe Admin::UsersController do
  
  describe "an anymouse users" do
    it "returns http success" do
      get 'index'
      response.should_not be_success
    end
  end
  
  describe "a logged in user" do
    login_user
    it "returns http success" do
      get 'index'
      response.should_not be_success
    end
  end
  
  describe "an admin user" do
    login_admin
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  end

end


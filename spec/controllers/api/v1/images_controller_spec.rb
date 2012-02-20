require 'spec_helper'

describe Api::V1::ImagesController do
  
  let(:valid_attributes) { Factory.attributes_for(:image)  }
  
  before(:each) do
    @user = Factory(:user)
    sign_in @user
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    
    it "should save an image" do
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id } )
      expect {
        post :create, :image => va, :auth_token => @user.authentication_token
      }.to change(Image, :count).by(1)
    end
    
    it "should give an error response if no auth_token is provided" do
      
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id } )
      expect {
        post :create, :image => va
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
    it "should give an error response if auth_token is incorrect" do
      @user     = Factory(:user)
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id } )
      expect {
        post :create, :image => va, :auth_token => "123"
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
  end
  
  describe "GET 'update'" do
    
    it "should add a caption to an image" do
      location = Factory(:location)
      image    = Factory(:image, {location: location, user: @user})
      put :update, :id => image.id, :image => { caption: "FooBar" }, :auth_token => @user.authentication_token
      response.body.should include("FooBar")
    end
    
    it "should give an error response if they try updating another @users image" do
      image = Factory(:image, {location: Factory(:location), user: Factory(:user)})
      xhr :put, :update, :format => "js", :id => image.id, :image => { caption: "FooBar" }, :auth_token => @user.authentication_token
      response.body.should include("You don't have permission to")
    end
    
    it "should give an error response if no auth_token is provided" do
      location = Factory(:location)
      image = Factory(:image, {location: location})
      put :update, :id => image.id, :image => { caption: "FooBar" }
      response.body.should include("Invalid authentication token")
    end

    it "should give an error response if auth_token is incorrect" do
      location = Factory(:location)
      image = Factory(:image, {location: location})
      put :update, :id => image.id, :image => { caption: "FooBar" }, :auth_token => "123"
      response.body.should include("Invalid authentication token")
    end
    
  end
  
end

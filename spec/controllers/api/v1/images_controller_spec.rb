require 'spec_helper'

describe Api::V1::ImagesController, :vcr do
  
  let(:valid_attributes) { FactoryGirl.attributes_for(:image)  }
  
  before(:each) do
    @user = FactoryGirl.create(:user)
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
      location = FactoryGirl.create(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id, :share_on_fb => true } )
      expect {
        post :create, :image => va, :auth_token => @user.authentication_token
      }.to change(Image, :count).by(1)
    end
    
    it "should give an error response if no auth_token is provided" do
      location = FactoryGirl.create(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id } )
      expect {
        post :create, :image => va
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
    it "should give an error response if auth_token is incorrect" do
      @user    = FactoryGirl.create(:user)
      location = FactoryGirl.create(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id } )
      expect {
        post :create, :image => va, :auth_token => "123"
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
    it "response should include_root_in_json" do
      location = FactoryGirl.create(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => @user.id, :share_on_fb => true } )
      post :create, :image => va, :auth_token => @user.authentication_token
      JSON.parse(response.body).has_key?("image").should be_true
    end
    
  end
  
  describe "GET 'update'" do
    
    it "should add a caption to an image" do
      location = FactoryGirl.create(:location)
      image    = FactoryGirl.create(:image, {location: location, user: @user})
      put :update, :id => image.id, :image => { caption: "FooBar" }, :auth_token => @user.authentication_token
      response.body.should include("FooBar")
    end
    
    it "should give an error response if they try updating another @users image" do
      image = FactoryGirl.create(:image, {location: FactoryGirl.create(:location), user: FactoryGirl.create(:user)})
      xhr :put, :update, :format => "js", :id => image.id, :image => { caption: "FooBar" }, :auth_token => @user.authentication_token
      response.body.should include("You don't have permission to")
    end
    
    it "should give an error response if no auth_token is provided" do
      location = FactoryGirl.create(:location)
      image = FactoryGirl.create(:image, {location: location})
      put :update, :id => image.id, :image => { caption: "FooBar" }
      response.body.should include("Invalid authentication token")
    end

    it "should give an error response if auth_token is incorrect" do
      location = FactoryGirl.create(:location)
      image = FactoryGirl.create(:image, {location: location})
      put :update, :id => image.id, :image => { caption: "FooBar" }, :auth_token => "123"
      response.body.should include("Invalid authentication token")
    end
    
  end
  
end

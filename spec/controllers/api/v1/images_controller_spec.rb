require 'spec_helper'

describe Api::V1::ImagesController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    
    let(:valid_attributes) { Factory.attributes_for(:image)  }
    
    it "should save an image" do
      user     = Factory(:user)
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => user.id } )
      expect {
        post :create, :image => va, :auth_token => user.authentication_token
      }.to change(Image, :count).by(1)
    end
    
    it "should give an error response if no auth_token is provided" do
      user     = Factory(:user)
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => user.id } )
      expect {
        post :create, :image => va
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
    it "should give an error response if auth_token is incorrect" do
      user     = Factory(:user)
      location = Factory(:location)
      va = valid_attributes.merge( { :location_id => location.id, :user_id => user.id } )
      expect {
        post :create, :image => va, :auth_token => "123"
      }.to change(Image, :count).by(0)
      response.body.should include("Invalid authentication token")
    end
    
  end

end

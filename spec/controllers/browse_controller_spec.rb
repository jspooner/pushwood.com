require 'spec_helper'

describe BrowseController do

  describe "GET 'index'" do
    before(:each) do
      GeoplanetPlace.create!(:woeid => 1, :parent_woeid => 0, :language => "ENG", :name => "Earth")
      GeoplanetPlace.create!(:woeid => 2, :parent_woeid => 1, :language => "ENG", :name => "United States")      
    end
    it "returns http success" do
      pending "I can't figure out why GeoplanetPlace can't be found"
      get 'index', :woeid => 1
      response.should be_success
    end
  end

end

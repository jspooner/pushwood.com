require 'spec_helper'

describe "Locations", :vcr do
  describe "GET /api/v1/locations/search.json?lat=33.107648&long=-117.217255&name=mission%20valley" do
    it "works! (now write some real specs)" do
      FactoryGirl.create(:location, :name => "Mission Valley YMCA Krause Family Skatepark")
      get api_v1_locations_path, :lat => "33.107648", :long => "-117.217255", :name => "mission%20valley"
      response.status.should be(200)
      JSON.parse(response.body).first["location"]["name"].should eql("Mission Valley YMCA Krause Family Skatepark")
    end
  end
end

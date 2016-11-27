require 'spec_helper'

describe "Locations" do
  describe "GET /locations" do
    it "works! (now write some real specs)" do
      get locations_path
      response.status.should be(200)
    end
  end
end

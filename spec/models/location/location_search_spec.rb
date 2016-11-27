require 'spec_helper'

describe "Location Searching", :elasticsearch, :vcr do
  let(:san_marcos_skate_park) do
    FactoryGirl.create(:location, { 
      name: "San Marcos Hollandia Park",
      lat: 33.14597451,
      lng: -117.14470474,
      address: "1 Mission Hills Ct, San Marcos, California 92069",
      street: "1 Mission Hills Ct",
      city: "San Marcos",
      state: "California",
      postal: "92069",
      country: "United States",
      phone: "619 370-7411",
      description: "This is prefab an concrete skatepark."
      })
  end
  let(:new_york_skate_park) do
    FactoryGirl.create(:location, { 
      name: 'New York Skate Park', 
      address: '1015 River Ave, New York, NY 10452', 
      lat: '40.83127200',
      lng: '-73.92431600',
      street: "1015 River Ave",
      city: "New York",
      state: "NY",
      postal: "10452",
      country: "United States",
      phone: "619 370-7411"
      })
  end
  
  context "Searching for 'San Marcos Hollandia Park'" do
    before(:each) do
      san_marcos_skate_park
      Location.index.refresh
    end
    it { Location.search({ query: 'San Marcos Hollandia Park' }).results.should eq [san_marcos_skate_park] }
    it { Location.search({ query: 'prefab' }).results.should eq [san_marcos_skate_park] }
    xit { Location.search({ query: 'Mission Hills Ct' }).results.should eq [san_marcos_skate_park] }
    it { Location.search({ query: 'San Marcos' }).results.should eq [san_marcos_skate_park] }
    it { Location.search({ query: 'California' }).results.should eq [san_marcos_skate_park] }
    it { Location.search({ query: '92069' }).results.should eq [san_marcos_skate_park] }
    it { Location.search({ query: 'USA' }).results.should eq [san_marcos_skate_park] }
  end
  
  context "within a given distance from a region" do
    before(:each) do
      # Define an event out in New York that should not be returned in our test searches
      san_marcos_skate_park
      new_york_skate_park
      Location.index.refresh
    end
    it { Location.search({ query: "New York Skate Park", lat_lon: '40.83127200, -73.92431600', radius: "50" }).results.should eq [new_york_skate_park] }
    xit { Location.search({ lat_lon: '40.83127200, -73.92431600', radius: '50' }).results.should eq [new_york_skate_park] }
  #   it "should find events within 50 miles of 92121" do
  #     Location.search({ location: '92121', radius: '50' }).results.should eq [@event]
  #   end
  #   it "should find events within 50 miles of New York, NY" do
  #     Location.search({ location: 'New York, NY', radius: '50' }).results.should eq [@event2]
  #   end
  end
  
end
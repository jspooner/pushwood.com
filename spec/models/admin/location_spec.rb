require 'spec_helper'

describe Admin::Location, :vcr do
  describe "Validating" do
    before(:each) do
      @locations = [FactoryGirl.create(:location, {:marker_verified=>false})]
      @locations << FactoryGirl.create(:location, {:marker_verified=>false})
      @locations << FactoryGirl.create(:location, {:marker_verified=>false})
      @locations << FactoryGirl.create(:location, {:marker_verified=>false})
    end
    it "should mass update verified locations" do
      verified_ids = @locations.map {|l| l.id}
      Admin::Location.markers_have_been_verified( verified_ids[0..2] ).should eq 3
      Location.find(verified_ids[0]).marker_verified.should be_true
      Location.find(verified_ids[1]).marker_verified.should be_true
      Location.find(verified_ids[2]).marker_verified.should be_true
      Location.find(verified_ids[3]).marker_verified.should be_false
    end
  end
  describe "Invalidating" do
    before(:each) do
      @locations = [FactoryGirl.create(:location, {:marker_verified=>true})]
      @locations << FactoryGirl.create(:location, {:marker_verified=>true})
      @locations << FactoryGirl.create(:location, {:marker_verified=>true})
      @locations << FactoryGirl.create(:location, {:marker_verified=>true})
    end
    it "should mass invalidate verified locations" do
      invalid_ids = @locations.map {|l| l.id}
      Admin::Location.markers_have_been_invalidated( invalid_ids[0..1] ).should eq 2
      Location.find(invalid_ids[0]).marker_verified.should be_false
      Location.find(invalid_ids[1]).marker_verified.should be_false
      Location.find(invalid_ids[2]).marker_verified.should be_true
      Location.find(invalid_ids[3]).marker_verified.should be_true      
    end
  end
end

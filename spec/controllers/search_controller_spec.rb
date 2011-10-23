require 'spec_helper'

describe SearchController do

  describe "GET 'index'" do
    it "should be successful" do
            response.should be_success
    end
    it "should call locations" do
      pending "should_receive(:near) should return a location class"
      Location.should_receive(:near).should_receive(:where).with( :query => "san diego")
      # Location.should_receive(:where).with( :query => "san diego")
      get 'index', :query => "san diego"
    end
  end

end

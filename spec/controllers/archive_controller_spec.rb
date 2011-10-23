require 'spec_helper'

describe ArchiveController do
  before(:each) do
    Factory(:location)
  end
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'country'" do
    it "should be successful" do
      get 'country', :country => "usa", :state => "ca"
      response.should be_success
    end
  end

  describe "GET 'state'" do
    it "should be successful" do
      get 'state', :country => "usa", :state => "ca"
      response.should be_success
    end
  end

  # describe "GET 'city'" do
  #   it "should be successful" do
  #     get 'city', :city => "san diego"
  #     response.should be_success
  #   end
  # end

end

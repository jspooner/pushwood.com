require 'spec_helper'

describe ArchiveController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'country'" do
    it "should be successful" do
      get 'country'
      response.should be_success
    end
  end

  describe "GET 'state'" do
    it "should be successful" do
      get 'state'
      response.should be_success
    end
  end

  describe "GET 'city'" do
    it "should be successful" do
      get 'city'
      response.should be_success
    end
  end

end

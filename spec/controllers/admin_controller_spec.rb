require 'spec_helper'

describe AdminController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'users'" do
    it "returns http success" do
      get 'users'
      response.should be_success
    end
  end

  describe "GET 'locations'" do
    it "returns http success" do
      get 'locations'
      response.should be_success
    end
  end

end

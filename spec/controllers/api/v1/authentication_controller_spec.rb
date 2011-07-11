require 'spec_helper'

describe Api::V1::AuthenticationController do

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'exists'" do
    it "should be successful" do
      get 'exists'
      response.should be_success
    end
  end

end

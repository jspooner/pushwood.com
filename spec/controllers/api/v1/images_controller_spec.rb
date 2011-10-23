require 'spec_helper'

describe Api::V1::ImagesController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  # describe "GET 'show'" do
  #   it "should be successful" do
  #     pending
  #     get 'show'
  #     response.should be_success
  #   end
  # end

  # describe "GET 'new'" do
  #   it "should be successful" do
  #     pending
  #     get 'new'
  #     response.should be_success
  #   end
  # end

  describe "GET 'create'" do
    it "should be successful" do
      get 'create'
      response.should be_success
    end
  end

end

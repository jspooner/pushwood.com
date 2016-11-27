require 'spec_helper'

describe Admin::LocationsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'multi_update'" do
    it "returns http success" do
      ids = "1, 2, 3"
      Admin::Location.should_receive(:markers_have_been_verified).with(ids.split(","))
      post 'multi_update', :verified_ids => ids
      response.should be_success
    end
    it "returns http success" do
      ids = "1, 2, 3"
      Admin::Location.should_receive(:markers_have_been_invalidated).with(ids.split(","))
      post 'multi_update', :invalid_ids => ids
      response.should be_success
    end
    
  end

end

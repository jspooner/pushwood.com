require 'spec_helper'

describe IphoneController do

  describe "GET 'feed'" do
    it "returns http success" do
      get 'feed'
      response.should be_success
    end
  end

end

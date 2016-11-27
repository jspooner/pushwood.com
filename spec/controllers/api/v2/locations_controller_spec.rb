require 'spec_helper'

describe Api::V2::LocationsController do
  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("mimi","knoop")
  end
  describe "POST create" do
    describe "with invalid params", :vcr do
      it "should have the full error message" do
        post :create, location: { name: nil }
        expect(response.body).to include '"error_messages":"Name can\'t be blank"'
      end
    end
  end
  
end
require 'spec_helper'

describe Api::V2::AuthenticationController, :vcr do
  
  render_views
  
  def http_login
    user = 'mimi'
    pw = 'knoop'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
  end
  
  describe "GET 'create'" do
    before { http_login }
    let(:token){"CAAC4m77AVg8BANX8ZAU35cZAzEGxCsiHCXCJlKOcru1BcgJkqL6JzlBjOmDVDVB1fQkXReq2zs4J5lzlWDybNK1DXmtqbiBJjUK3CHXNYVN00ToEZCBA51xgDZAJyhyHV6iaxDQEZCdZA5tZAMcH1zyWZCbn1fUXRiuASLi3NthDcnNWJ8FWg3sm"}
    let(:user_json){ JSON.parse '{
      "id" : "541557649",
      "timezone" : -7,
      "username" : "the.real.jonathan.spooner",
      "link" : "http:\/\/www.facebook.com\/the.real.jonathan.spooner",
      "location" : {
        "id" : "110714572282163",
        "name" : "San Diego, California"
      },
      "quotes" : "\"Life is what happens to you when your making other plans.\"\r\n       John Lennon",
      "locale" : "en_US",
      "favorite_athletes" : [
        {
          "id" : "132895990110884",
          "name" : "Mimi Knoop"
        },
        {
          "id" : "114077461941465",
          "name" : "Allysha Bergado"
        },
        {
          "id" : "172764332870213",
          "name" : "Murilo Peres"
        },
        {
          "id" : "131112500358213",
          "name" : "Rune Glifberg"
        },
        {
          "id" : "471957336188211",
          "name" : "Oscar Meza"
        },
        {
          "id" : "172764332870213",
          "name" : "Murilo Peres"
        }
      ],
      "last_name" : "Spooner",
      "birthday" : "03\/19\/1981",
      "email" : "jspooner@pushwood.com",
      "sports" : [
        {
          "id" : "105564129477738",
          "name" : "Skateboarding"
        }
      ],
      "verified" : true,
      "gender" : "male",
      "name" : "Jonathan Spooner",
      "political" : "Reagan Conservative",
      "first_name" : "Jonathan",
      "updated_time" : "2013-05-08T20:36:33+0000"
    }'
    }
    it "creates a new user and authenicates them" do
      request.env['CONTENT_TYPE'] = 'application/json'
      post :create, {
        facebook_user: user_json,
        facebook_token: token
      }, format: :json
      response.should be_success
      assigns(:user).should_not be_nil
      assigns(:user).email.should eql("jspooner@pushwood.com")
      json = JSON.parse(response.body)
      json["user"]["authentication_token"].should_not be_nil

    end
    it "authenticates a current user" do
      user = FactoryGirl.create(:user)
      post :create, {
        facebook_user: user_json,
        facebook_token: token
      }
      response.should be_success
      assigns(:user).should_not be_nil
      assigns(:user).email.should eql("jspooner@pushwood.com")
      json = JSON.parse(response.body)
      json["user"]["authentication_token"].should_not be_nil
    end
  end

end


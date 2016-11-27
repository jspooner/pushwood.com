require 'spec_helper'

describe Image, :vcr do
  describe "Post to facebook" do
    include Rails.application.routes.url_helpers
    # it "should have a curl command" do
    #   Rails.application.routes.default_url_options[:host] = 'localhost:3000' # TODO Figure out why I need this
    #   user     = Factory(:user)
    #   user.authentications.create!(:provider => 'facebook', :uid => '444', :token => "AAA666")
    #   location = Factory(:location)
    #   image    = Factory(:image, :user => user, :location => location)
    #   image.curl_photograph.should eql "- F access_token=AAA666 -F skate_park=#{location_url location} https://graph.facebook.com/me/pushwood:photograph"
    # end
    it "should post to FB" do
      pending
      Rails.application.routes.default_url_options[:host] = 'localhost:3000' # TODO Figure out why I need this
      user     = Factory(:user)
      user.authentications.create!(:provider => 'facebook', :uid => '444', :token => "AAA666")
      location = Factory(:location)
      image    = Factory(:image, :user => user, :location => location)
      # image.post_to_facebook.should eql("foo")
    end
  end
end


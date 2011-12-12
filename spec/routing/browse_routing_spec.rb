require "spec_helper"

describe BrowseController do
  describe "routing" do

    it "should get skateparks" do
      { :get => "/skateparks" }.should route_to(:controller => "browse", :action => "index")
    end

  end
end

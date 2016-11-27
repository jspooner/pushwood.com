require 'spec_helper'

describe Location, :vcr do
  describe "creation" do
    it "should set lat and lng if given address" do
      location = Location.create!({ :name => "San Marcos", 
                                    :street => "12 E Mission Hills Ct",
                                    :city => "San Marcos",
                                    :state => "California",
                                    :postal => "92069",
                                    :country => "United States"});
      location.lat.should_not be_nil
      location.lng.should_not be_nil
    end
  
    it "should set the address if given lat and lng" do
      location = Location.create!({ :name => "Foo Bar", :lat => "33.140862", :lng => "-117.158827" })
      location.street.should_not be_nil
      location.city.should_not be_nil
      location.state.should_not be_nil
      location.postal.should_not be_nil
      location.country.should_not be_nil
    end
    # allow the lat and long to be adjusted without changing the address
    it "should not change the address" do
      location = Location.create!({ :name => "San Marcos", 
                                    :street => "400 E Mission Hills Ct",
                                    :city => "San Marcos",
                                    :state => "California",
                                    :postal => "92069",
                                    :country => "United States"});
      street       = location.street
      city         = location.city
      state        = location.state
      postal       = location.postal
      country      = location.country
      location.lat = 37.6360874401032
      location.lng = -89.0127259807095
      location.lng.should_not be_nil
      location.save
    
      location.street.should eql("400 E Mission Hills Ct")
      location.city.should eql(city)
      location.state.should eql(state)
      location.postal.should eql(postal)
      location.country.should eql(country)
    end
  
    it "if the address is cleared it should be populated from the new lat/lng" do
      location = Location.create!({ :name => "San Marcos", 
                                    :street => "12 E Mission Hills Ct",
                                    :city => "San Marcos",
                                    :state => "California",
                                    :postal => "92069",
                                    :country => "United States"});
      location.lat     = 33.13699933652728
      location.lng     = -117.26627742538449
    
      location.street  = ""
      location.city    = ""
      location.state   = ""
      location.postal  = ""
      location.country = ""
      location.save
      location.street.should_not eql("")
      location.city.should_not eql("")
      location.state.should_not eql("")
      location.postal.should_not eql("")
      location.country.should_not eql("")
    
    end
  end
  describe "marker verification" do
    before(:each) do
      @location = Location.create!({:name    => "San Marcos", 
                                    :street  => "400 E Mission Hills Ct",
                                    :city    => "San Marcos",
                                    :state   => "California",
                                    :postal  => "92069",
                                    :country => "United States",
                                    :lat     => 37.6360874401032,
                                    :lng     => -89.0127259807095
                                    });
    end
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    let(:request) { mock(ActionDispatch::Request, {:ip => "127.0.0.1" }) }
    # it { request.instance_of?(ActionDispatch::Request).should be_true }
    # it { request.ip.should eql("127.0.0.1") }
    it "should upvote" do
      @location.marker_contributors << 10
      @location.marker_contributors.values.should eql ["10"]
    end
    # it { @location.verify_marker("yes", nil).should be_nil }
    it { @location.verify_marker("yes", user.id).should_not be_nil }
    it { @location.verify_marker("yes", request.ip).should_not be_nil }
    it "shouldn't let a user vote twice" do
      @location.verify_marker("yes", "1")[:status].should be_true
      @location.verify_marker("yes", "1")[:status].should be_true
      # @location.verify_marker("yes", "1")[:message].should eq("You already voted")
    end
    it "should increment the marker yes vote" do
      @location.verify_marker("yes", user.id)[:status].should be_true
      @location.marker_yes.value.should eql 1
      @location.marker_no.value.should eql 0
    end
    it "should increment the marker no vote" do
      @location.verify_marker("no", user.id)[:status].should be_true
      @location.marker_yes.value.should eql 0
      @location.marker_no.value.should eql 1
    end
    it "should increment the marker no vote" do
      @location.verify_marker("yes", user.id)[:status].should be_true
      @location.verify_marker("no", user2.id)[:status].should be_true
      @location.marker_yes.value.should eql 1
      @location.marker_no.value.should eql 1
    end
    it "should increment the marker no vote" do
      @location.verify_marker("yes", user.id)[:status].should be_true
      @location.verify_marker("yes", user2.id)[:status].should be_true
      @location.marker_yes.value.should eql 2
      @location.marker_no.value.should eql 0
    end
    it "should increment the marker no vote" do
      @location.verify_marker("yes", user.id)[:status].should be_true
      @location.marker_verified.should be_false
      
      @location.verify_marker("yes", user2.id)[:status].should be_true
      @location.marker_verified.should be_false
      
      @location.verify_marker("yes", user3.id)[:status].should be_true
      @location.marker_verified.should be_true
    end
    it "should keep a list of recently approved locations" do
      @location.verify_marker("yes", user.id)[:status].should be_true
      @location.verify_marker("yes", user2.id)[:status].should be_true
      @location.verify_marker("yes", user3.id)[:status].should be_true
      @location.marker_verified.should be_true
      JSON.parse(Location.recent_verified_markers[0])["location_id"].should eq(@location.id)
    end
    it "should keep a list of recently rejected locations" do |variable|
      pending "$redis.some location rejected list should include @location"
    end
    it "should keep a list of recently confused locations" do
      pending "$redis.some location confused list should include @location"
    end
  end
  describe "google map cache" do
    before(:each) do
      @location = Location.create!({ :name => "San Marcos", 
                                  :street  => "400 E Mission Hills Ct",
                                  :city    => "San Marcos",
                                  :state   => "California",
                                  :postal  => "92069",
                                  :country => "United States",
                                  :lat     => 32.96039944,
                                  :lng     => -117.10972085
                                  });
    end
    after(:each) { 
      File.delete "./public/system/staticmaps/#{@location.id}.jpg" rescue nil 
      File.delete "./public/system/staticmaps/#{@location.id}_ios.jpg" rescue nil 
    }
    
    it "should download and save a map" do
      @location.cache_google_staticmap.should be_true
      @location.google_staticmap.should eql "http://localhost:3000/system/staticmaps/#{@location.id}.jpg"
      File.exists?("./public/system/staticmaps/#{@location.id}.jpg").should be_true
      File.exists?("./public/system/staticmaps/#{@location.id}_ios.jpg").should be_true
    end
    it "should default to google maps" do
      pending "These test interfear with the development public directory"
      @location.cache_google_staticmap.should_receive(:open).and_raise(OpenURI::HTTPError)
      @location.cache_google_staticmap.should be_false
      @location.google_staticmap.should eql "http://maps.google.com/maps/api/staticmap?center=32.96039944,-117.10972085&zoom=20&size=528x400&maptype=hybrid&markers=color:blue|label:A|32.96039944,-117.10972085&sensor=false"
      File.exists?("./public/system/staticmaps/#{@location.id}.jpg").should be_false
    end
    # If a user exceeds these limits, the server will return an HTTP 403 status and display the below image to indicate that the quota has been exceeded:
    it "should handle a 403" do
      exception_io = mock('io')
      exception_io.stub_chain(:status,:[]).with(0).and_return('403')
      @location.stub(:open).and_raise(OpenURI::HTTPError.new('403 Forbidden',exception_io))
      @location.cache_google_staticmap.should be_false
      @location.google_staticmap.should eql "http://maps.google.com/maps/api/staticmap?center=32.961456,-117.1069599&zoom=20&size=528x400&maptype=hybrid&markers=color:blue|label:A|32.961456,-117.1069599&sensor=false"
      File.exists?("./public/system/staticmaps/#{@location.id}.jpg").should be_false
    end
    
  end
end

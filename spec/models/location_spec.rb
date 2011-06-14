require 'spec_helper'

describe Location do
  
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
    location = Location.create!({ :lat => "33.140862", :lng => "-117.158827" })
    location.street.should_not be_nil
    location.city.should_not be_nil
    location.state.should_not be_nil
    location.postal.should_not be_nil
    location.country.should_not be_nil
  end
  
  it "should allow the lat and long to be adjusted without changing the address" do
    location = Location.create!({ :name => "San Marcos", 
                                  :street => "12 E Mission Hills Ct",
                                  :city => "San Marcos",
                                  :state => "California",
                                  :postal => "92069",
                                  :country => "United States"});
    street  = location.street
    city    = location.city
    state   = location.state
    postal  = location.postal
    country = location.country
    location.lat = 37.6360874401032
    location.lng = -89.0127259807095
    location.save
    
    location.street.should eql(street)
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

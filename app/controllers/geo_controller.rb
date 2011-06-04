class GeoController < ApplicationController

  # Search Geocoding API
  # 
  # Search for geographic information about a street address, IP address, or set of coordinates (Geocoder.search returns an array of Geocoder::Result objects):
  # 
  # Geocoder.search("1 Twins Way, Minneapolis")
  # Geocoder.search("44.981667,-93.27833")
  # Geocoder.search("204.57.220.1")
  def search
    results = Geocoder.search(params[:q])
    h = {}
    h[:street] = results.first.address_data["addressLine"]
    h[:city] = results.first.city
    h[:state] = results.first.state
    h[:country] = results.first.country
    h[:postal] = results.first.postal_code
    respond_to do |format|
      format.json { render :text => h.to_json() }
    end
  end
  
  def ios_search
    locations = Location.where("name LIKE ?", "%#{params[:q]}%").all
    h = {}
    respond_to do |format|
      format.json { render :text => Location.build_json(locations) }
    end    
  end
  
end
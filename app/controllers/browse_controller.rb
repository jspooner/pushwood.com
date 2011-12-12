class BrowseController < ApplicationController
  
  def index
  end
  
  def country
    load_country
    @place = @country
    gon.place = @place
    
    @locations = Location.where("country = ?", @place.name).limit(20).order("rating_average DESC")
    render "index"
  end
  
  def location
    load_country
    @place = GeoplanetPlace.where("country_code = ? AND name = ?", @country.country_code, params[:location].try(:titleize)).first
    gon.place = @place
    
    @locations = Location.where("state = ?", Carmen::state_code(@place.name)).all
    
    render "index"
  end
  
  protected
    
    def load_country
      @country = GeoplanetPlace.where("place_type = 'Country'").find_by_name( Carmen::country_name(params[:country].try(:upcase)) )
    end
    
end

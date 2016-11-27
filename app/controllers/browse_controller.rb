class BrowseController < ApplicationController
  
  def index
    woeid      = params[:woeid] || 1
    @place     = GeoplanetPlace.find_by_woeid(woeid)
    gon.place  = @place
    # @parent  = GeoplanetPlace.find_by_woeid(@place.parent_woeid)
    @sub_places = GeoplanetPlace.where("parent_woeid = ? and (place_type = 'Country' or place_type = 'State' or place_type = 'County' or place_type = 'Town')", @place.woeid).order("name")
    @locations = Location.in_bounds(@place.bounding_box).order("rating_average DESC").page(params[:page]||1)
    if @place.place_type == "State"
      code = Carmen::state_code(@place.name)
      state = Carmen::state_name(@place.name) || @place.name
      logger.info { "state_code=#{code}, state_name#{state.blank?}" }
      @locations = @locations.where("state = ? or state = ?", code, state) if code and state
    end
    if @place.place_type == "Country"
      state_code = Carmen::country_code(@place.name)
      state_name = Carmen::country_name(@place.name) || @place.name
      logger.info { "state_code=#{state_code}, state_name#{state_name}" }
      @locations = @locations.where("country = ? or country = ?", state_code, state_name) if state_code and state_name
    end
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

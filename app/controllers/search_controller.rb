class SearchController < ApplicationController
  def index
    @query          = params[:q]
    @query_location = params[:l]
    params[:per_page] = 10
    params[:query]  = params[:q] unless params[:q].nil?
    params.delete("facet_locations") if params[:facet_locations] == 'all' #or params[:facet_locations] == 'facet_location_current'
    params.delete("facet_features") if params[:facet_features] == 'all'
    if params[:facet_locations] == 'facet_location_current'
      params[:lat_lon] = "#{request.location.latitude},#{request.location.longitude}"
      params[:radius]  = "50"
      params.delete("facet_locations")
    end
    logger.info { "-------------------------------  #{params}" }
    @locations = Location.search params
    gon.location = @locations.first
  end
end
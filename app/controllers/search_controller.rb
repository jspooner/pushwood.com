class SearchController < ApplicationController
  def index
    @query          = params[:q]
    @query_location = params[:l]
    
    @locations = Location.limit(25)
    @locations = @locations.where("city LIKE ? or state LIKE ? or postal LIKE ? or name LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%")
  end
end
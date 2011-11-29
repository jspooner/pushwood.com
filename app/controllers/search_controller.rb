class SearchController < ApplicationController
  def index
    @query          = params[:q]
    @query_location = params[:l]
    
    @locations = Location.where("city LIKE ? or state LIKE ? or postal LIKE ? or name LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%").paginate(:page => params[:page], :per_page => 30)
  end
end
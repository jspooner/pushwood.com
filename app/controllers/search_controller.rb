class SearchController < ApplicationController
  def index
    @query     = params[:q]
    @locations = Location.limit(25).where("city LIKE ? or state LIKE ? or postal LIKE ? or name LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%")
  end
end
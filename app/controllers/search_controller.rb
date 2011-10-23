class SearchController < ApplicationController
  def index
    points_str = "#{params[:lat]},#{params[:long]}"
    @locations = Location.near(points_str , 100).where("city LIKE ? or state LIKE ? or postal LIKE ? or name LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
  end
end
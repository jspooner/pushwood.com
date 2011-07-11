class Api::V1::RatingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    comments = []
    if params[:location_id]
      comments = Comment.where("commentable_id = ?", params[:location_id]).reverse
    end
    respond_to do |format|
      format.json { render :json => comments.to_json }
    end
  end
  
  def create
    # logger.info { "RatingsController.create #{params.inspect}" }
    logger.info { "RatingsController.create comment is #{params[:comment]}  #{params[:location_id]}" }
    if params[:location_id]
      @location = Location.find( params[:location_id] )
      @location.comments.create(:comment => params[:comment], :commentable_id => @location.id, :commentable_type => @location.class.name, :user_id => params[:user_id])
      render :text => "Success"
    end
  end
end
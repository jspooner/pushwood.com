class Api::V1::ImagesController < ApplicationController
  
  respond_to :json
  
  def index
    if params[:location_id]
      @images = Location.find(params[:location_id]).images
    else
      @images = Image.all
    end
  end

  def show
  end

  def new
  end

  def create
    unless @user = User.find_by_authentication_token(params[:auth_token])
      render :json => {:errors => ["Invalid authentication token"]}, :status => 401
      return
    end
    
    @image = Image.new(params[:image])
    if @image.save
      # render :json => @image.to_json
    else
      # render :json => {:errors => @image.errors}, :status => 401
    end
  end
  
  
end

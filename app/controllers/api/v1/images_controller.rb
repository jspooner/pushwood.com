class Api::V1::ImagesController < ApplicationController

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
    @image = Image.create(params[:image])
    unless @image
      render :json => {:errors => ["Invalid something"]}, :status => 401
      return
    end
  end

end

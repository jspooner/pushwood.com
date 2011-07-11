class Api::V1::ImagesController < ApplicationController
  def index
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

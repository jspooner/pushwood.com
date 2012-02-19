class Api::V1::ImagesController < ApplicationController
  before_filter :authorize, :only => [:create, :update]
  respond_to :json
  load_and_authorize_resource :image #:except => [:verify_marker]
  
  def index
    if params[:location_id]
      @images = Location.find(params[:location_id]).images.approved
    else
      @images = []
    end
  end

  def show
  end

  def new
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      render :json => @image.to_json
    else
      render :json => {:errors => @image.errors}, :status => 401
    end
  end
  
  def update
    @image = Image.find(params[:id])
    
    if @image.update_attributes(params[:image])
      render :json => @image.to_json
    else
      render :json => {:errors => @image.errors}, :status => 401
    end

  end
  
  private
    
    def authorize
      unless @user = User.find_by_authentication_token(params[:auth_token])
        render :json => {:errors => ["Invalid authentication token"]}, :status => 401
        return
      end
    end
  
end

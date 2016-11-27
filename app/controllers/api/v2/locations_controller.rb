class Api::V2::LocationsController < API::V2::BaseController
  skip_before_filter :verify_authenticity_token
  
  def index
    limit  = params[:limit] || 100

    @locations = Location.scoped
    @locations = @locations.limit(limit)
    @locations = @locations.where("lat IS NOT NULL && lng IS NOT NULL && city IS NOT NULL && state IS NOT NULL && country IS NOT NULL")
    @locations = @locations.where("updated_at > ?", DateTime.parse(params[:updated_after]).in_time_zone) if params[:updated_after]
    respond_to do |format|
      format.json { render :json => @locations.to_json(:only => [:id, :name, :city, :state, :country, :lat, :lng, :updated_at, :created_at]) }
    end
  end
  
  def show
    @location = Location.find(params[:id])
    # render :json => @location.to_json(:include => [:images])
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      UgcMailer.change_email(current_user, @location).deliver unless current_user.role?(:admin)
      render :show
    else
      render :json => @location.errors.to_json
    end
  end
  
  def create
    # render status: 500
    @location          = Location.new(params[:location])
    @location.approved = false
    @location.user     = current_user
    # @location.status   = "NewFromV2API"
    if @location.save
      render json: @location.to_json
    else
      json = @location.to_json(:methods => [:errors])
      json = JSON.parse(json).merge(error_messages: @location.errors.full_messages.join(" and ")).to_json
      render status: :unprocessable_entity, json: json
    end
  end
  
end

class LocationsController < ApplicationController
  # protect_from_forgery :except => [:update, :create]
  skip_before_filter :verify_authenticity_token
  
  authorize_resource :except => [:verify_marker]
  
  # GET /locations
  def index
    @locations = Location.unscoped.where(approved: false).order("created_at DESC").limit(50) # 
    # redirect_to "battles/top-skateparks"
  end

  # GET /locations/1
  def show
    @location    = Location.find(params[:id])
    gon.location = @location
    @images      = @location.images.approved.paginate(:page => params[:page], :per_page => 1)
    @location.revert_to(params[:version].to_i) if params[:version]
    
    respond_to do |format|
      format.html
      format.json  { render :text => @location.to_json(:methods => [:google_map_url, :lat, :lng]) }
      format.js
    end
  end
  
  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @location }
      format.json { render :text => @location.to_json }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])
    @location.user = current_user
    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
        format.json { render :text => @location.to_json }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.json { render :text => @location.to_json }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])
    #
    # TODO tag the version edit with the current_user.id
    # @location.tag_version(current_user.id)
    #
    respond_to do |format|
      @location.updated_by = current_user
      if @location.update_attributes(params[:location])
        UgcMailer.change_email(current_user, @location).deliver unless current_user.role?(:admin)
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
        format.json { @location.to_json }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.json { @location.errors.to_json }
      end
    end
  end
  
  def revert
    @location = Location.find(params[:id])
    redirect_to(@location) if params[:version].nil?
    authorize! :revert, @location

    if @location.revert_to!(params[:version].to_i)
      notice = "#{@location.name} was successfully reverted to version #{params[:version]}."
    else
      notice = 'Location was not reverted.'
    end
    redirect_to(@location, :notice => notice)
  end
  
  # POST
  def rate
    authorize! :rate, Location
    @location = Location.find(params[:id])
    respond_to do |format|
      if @location.rate(params[:stars], current_user, params[:dimension])
        format.js { render "_rating" }
      else
        format.js { render "_rating" }
      end
    end
  end
  
  # POST
  def verify_marker
    @location = Location.find(params[:id])
    response  = @location.verify_marker( params[:visible], (current_user) ? current_user.id : request.ip )
    respond_to do |format|
      format.json { render :text => response.to_json }
    end
  end
   
  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
end

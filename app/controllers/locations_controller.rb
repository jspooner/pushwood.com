class LocationsController < ApplicationController
  # protect_from_forgery :except => [:update, :create]
  skip_before_filter :verify_authenticity_token
  
  authorize_resource
  
  def countries
    @countries = Location.select("DISTINCT country").collect { |i| i.country }.compact!.sort
    respond_to do |format|
      format.json { render :text => @countries.to_json }
    end
  end
  
  def states
    country = params[:country]
    @states = Location.select("DISTINCT state").where("country = ?", country)
    @states = @states.collect { |i| i.state }
    @states.sort! unless @states.empty?
    @states.compact! unless @states.empty?
    respond_to do |format|
      format.json { render :text => @states.to_json }
    end
  end
  
  def cities
    state = params[:state]
    @cities = Location.select("DISTINCT city").where("state = ?", state)
    @cities = @cities.collect { |i| i.city }
    # BUG NEED TO SORT
    # @cities.sort!
    respond_to do |format|
      format.json { render :text => @cities.to_json }
    end        
  end
  
  # GET /locations
  # GET /locations.xml
  def index
    # @locations = Location.limit(20).where("state = ?", "CA").all

    radius     = params[:radius] || 200
    limit      = 50
    @locations = Location.limit(limit)
    @locations = @locations.in_bounds(params[:bounding_box]) if params[:bounding_box]
    
    # @locations = Location.near("San Marcos, CA, USA")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
      format.js
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    @location.revert_to(params[:version].to_i) if params[:version]
 
    # @json = @location.bounding_box 
    # @tricks = Trick.all :conditions => ["lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", @json['sw']['lat'], @json['ne']['lat'], @json['ne']['lng'], @json['sw']['lng'] ]
    # @tricks = Trick.all :conditions => ["lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", @location.bounding_box['sw']['lat'], @location.bounding_box['ne']['lat'], @location.bounding_box['ne']['lng'], @location.bounding_box['sw']['lng'] ]
    @tricks = []
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
      format.json  { render :text => @location.to_json(:methods => [:google_map_url, :lat, :lng]) }
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
        UgcMailer.change_email(current_user, @location).deliver # TODO https://github.com/scottwater/resque_mail_queue
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
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
   
  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
end

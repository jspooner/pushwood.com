class Api::V1::LocationsController < ApplicationController
  # protect_from_forgery :except => [:update, :create]
  skip_before_filter :verify_authenticity_token

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
  
  def search
    # lat        = params[:lat].to_i
    # long       = params[:long].to_i
    # points_arr = [lat,long]
    points_str = "#{params[:lat]},#{params[:long]}"
    @locations = Location.near(points_str , 100).where("city LIKE ? or state LIKE ? or postal LIKE ? or name LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%", "%#{params[:name]}%", "%#{params[:name]}%")
    # # Rails.logger.info { "----------  locations #{@locations}" }
    if @locations.nil?
      Rails.logger.info { "Doing second location search" }
      @locations = Location.near(points_str, 3000).where("address LIKE ? or name LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
    end

    if @locations.nil?
      Rails.logger.info { "Doing third location search" }
      @locations = Location.near(params[:name])
    end

    if @locations.nil?
      Rails.logger.info { "Doing fourth location search" }
      @locations = Location.where("address LIKE ? or name LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")      
    end

  end
  
  # GET /api/v1/locations.json?radius=20&limit=10&point=32,-112
  # radius in miles
  # limit
  # point [ lat, lng ]
  # OR
  # bounds   "lat_lo,lng_lo,lat_hi,lng_hi"
  # for this bounds, where "lo" corresponds to the southwest corner of the bounding box, while "hi" corresponds to the northeast corner of that box.
  def index
    radius = params[:radius] || 200
    limit  = params[:limit] || 100

    if params[:point] # use the geo gem that doesn't support AReL ;(
      points = params[:point].split(",").map { |i| i.to_i }
      @locations = Location.near(params[:point], radius, { :limit => limit, :include => [:ratings] })
      # @locations = Location.near(points, radius, { :limit => limit, :include => [:ratings] })
    else
      @locations = Location.scoped
      @locations = @locations.limit(limit)
      @locations = @locations.where("city = ?", params[:city])  if params[:city]
      @locations = @locations.in_bounds(params[:bounds])        if params[:bounds]
    end
    logger.info { "NUMBER OF RESULTS #{@locations.length}" }
  end
  
  def region
    render :text => "foo"
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

    # @json = @location.bounding_box 
    # @tricks = Trick.all :conditions => ["lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", @json['sw']['lat'], @json['ne']['lat'], @json['ne']['lng'], @json['sw']['lng'] ]
    @tricks = Trick.all :conditions => ["lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", @location.bounding_box['sw']['lat'], @location.bounding_box['ne']['lat'], @location.bounding_box['ne']['lng'], @location.bounding_box['sw']['lng'] ]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
      format.json  { render :text => @location.to_json(:methods => [:google_map_url, :lat, :lng]) }
    end
  end

  # GET 
  def images
    # @location = Location.find(params[:location_id])

    respond_to do |format|
      # format.json  { render :text => Location.build_images_json(@location.tricks) }
      format.json  { render :text => [].to_json }
    end

  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
    @tricks   = Trick.all
    respond_to do |format|
      format.html # new.html.erb
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
    logger.info { "PARAMS #{params.inspect}"}
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

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
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

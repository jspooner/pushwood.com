class PlacesController < ApplicationController
  
  # prepend_before_filter :prepare_params, :set_navigation
  
  def index
    prepare_params
    # @search = Taxonomy.new.search({country: @country})  # , state: @state
    # @results = @search.results
    set_navigation
    # render :text => "#{@country}, #{@state}, #{@city}"
    @locations   = Location.paginate(:page => params[:page], :per_page => 10).order("marker_verified DESC, name")
    @locations   = @locations.where("country = (?)", @country.titleize) if @country
    @locations   = @locations.where("state = (?)", @state.titleize) if @state
    @locations   = @locations.where("city = (?)", @city.titleize) if @city
    gon.location = @locations.first
  end
  
  protected
    
    def prepare_params
      @country, @state, @city = params[:id].split("/") rescue [nil,nil,nil]
    end
    
    def set_navigation
      @tire = Tire::Search::Search.new(Location.index_name)
      
      @nav = if @country and @state
        @tire.facet :cities, :global => true do |search|
          search.terms :city, :size => 50
          search.facet_filter :term, { :country => @country.titleize, :state => @state.titleize }
        end
        puts @tire.to_json
        @tire.results.facets['cities']['terms']
      elsif @country
        @tire.facet :states, :global => true do |search|
          search.terms :state, :size => 50
          search.facet_filter :term, { :country => @country.titleize }
        end
        @tire.results.facets['states']['terms']
      else
        @tire.facet :countries, :global => true do
          terms :country, :size => 50
        end
        @tire.results.facets['countries']['terms']
      end
    end
    # def set_navigation
    #   @nav = if @country.nil? and @state.nil?
    #     @results.facets['countries']['terms']
    #   elsif @country and @state.nil?
    #     @results.facets['states']['terms']
    #   elsif @country and @state
    #     @results.facets['states']['terms']
    #   else
    #     [{"term"=>"Foo"}]
    #   end
    # end
  
end

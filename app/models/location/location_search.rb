class Location < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  
  mapping do
    indexes :id, :index => :not_analyzed
    indexes :name, boost: 50, analyzer: "standard"
    indexes :description, analyzer: "snowball"
    indexes :street
    indexes :postal, :index => :not_analyzed
    indexes :city, boost: 15, :index => :not_analyzed
    indexes :state, boost: 15, :index => :not_analyzed
    indexes :country, boost: 15, :index => :not_analyzed
    indexes :address
    indexes :lat_lon, type: 'geo_point'
    indexes :marker_verified, type: 'boolean', null_value: false
    indexes :location_tags, analyzer: 'keyword', boost: 15
  end

  include_root_in_json = false
  def to_indexed_json
    to_json :except => [
      "created_at",
      "bounding_box",
      "updated_at",
      "is_free", 
      "is_outdoors", 
      "pads_required", 
      "has_concrete", 
      "has_lights", 
      "has_wood", 
      "cd_page_id", 
      "images_count", 
      "rating_average",
      "lng",
      "lat"],
      :methods => [
        :type,
        :lat_lon,
        :latitude,
        :longitude,
        :location_tags,
        :feature_tags
        ]
  end
  
  def type
    "geo_point"
  end
  
  def feature_tags
    tags = []
    tags << "free" if self.is_free?
    tags << "pads_required" if self.pads_required?
    tags << "outdoors" if self.is_outdoors?
    tags << "indoors" unless self.is_outdoors?
    tags << "concrete" if self.has_concrete?
    tags << "wood" if self.has_wood?
    
    tags
  end
  
  def location_tags
    [postal, city, state, country].compact.map(&:parameterize)
  end
  
  def lat_lon
    [lat, lng].join(',')
  end

  def latitude
    lat.to_f
  end

  def longitude
    lng.to_f
  end
  
  def self.keyword_search(query)
    tire.search(load: true) do
      query do
        string options
      end
      facet 'global-locations', :global => true do
        terms :location
      end
      facet 'current-locations'do
        terms :location
      end
    end
  end
  
  # Feed me a hash of Search options.
  # If passed a single string, query only on that.
  # If passed a hash, assemble the options into the Tire DSL.
  # Returns: Tire::Search object
  #   Call .results to get a Results::Collection
  def self.search(options = {})
    if options.is_a? String
      self.keyword_search options
      return
    end
    options = HashWithIndifferentAccess.new(options)
    logger.info { "--------------- options #{options}" }
    
    # Search by the full hash
    tire.search(load: true, page: options[:page]) do
      query do
        boolean do
          must { string options[:query], default_operator: "AND" } if options[:query].present?
          must { string "location_tags:#{options[:facet_locations].split(",").join(' ')}", default_operator: "OR" } if options[:facet_locations].present?
          must { string "feature_tags:#{options[:facet_features]}" } if options[:facet_features].present?
        end
      end  
      
      if options[:lat_lon].present? and options[:radius].present?
        filter :geo_distance, :lat_lon => options[:lat_lon], distance: options[:radius].to_s + 'mi'
        sort do
          by :_geo_distance, :lat_lon => options[:lat_lon], :unit => "mi"
        end
      end
      
      facet 'global-locations', :global => true do
        terms :location_tags
      end
      facet 'current-locations'do
        terms :location_tags
      end
      facet 'global-features', :global => true do
        terms :feature_tags
      end
      facet 'current-features'do
        terms :feature_tags
      end
      
      size( options[:per_page].to_i ) if options[:per_page]
      from( options[:page].to_i <= 1 ? 0 : (options[:per_page].to_i * (options[:page].to_i-1)) ) if options[:page] && options[:per_page]
    end # tire.search

  end
  
  def self.create_search_index
    create_elasticsearch_index
  end

  def self.delete_search_index
    index.delete
  end
  
end
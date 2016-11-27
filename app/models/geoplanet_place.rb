class GeoplanetPlace < ActiveRecord::Base
 
  self.primary_key = 'woeid'
  
  has_ancestry

  has_many :aliases, :class_name => 'GeoplanetAlias', :foreign_key => 'woeid', :dependent => :destroy
  has_many :adjacencies, :class_name => 'GeoplanetAdjacency', :foreign_key => 'woeid', :dependent => :destroy
  has_many :adjacent_places, :through => :adjacencies
  
  scope :us, :conditions => { :country_code => "US" }
  scope :county, :conditions => { :place_type => "County" }

  # validates_uniqueness_of :slug, :if => lambda { |gpp| !gpp.slug.nil? }
  
  serialize :bounding_box
    
  def bounding_box
    if self[:bounding_box].nil?
      self.update_attribute :bounding_box, GeoPlanet::Place.new( woeid ).bounding_box.to_json
      logger.info { "[GeoplanetPlace] load bounding_box for #{woeid}    data = #{self[:bounding_box]}" }
    end
    JSON.parse self[:bounding_box]
  end

  # {:sw => [lat,lng], :ne => [lat,lng]}
  def bounding_box_hash
    {:sw => [bounding_box[0][0],bounding_box[0][1]], :ne => [bounding_box[1][0],bounding_box[1][1]]}
  end
 
  def self.build_ancestry_from_parent_ids! parent_id = nil, ancestry = nil
    parent_id = parent_id || -1
    self.base_class.all(:conditions => {:parent_woeid => parent_id}).each do |node|
      node.without_ancestry_callbacks do
        node.update_attribute ancestry_column, ancestry
      end
      build_ancestry_from_parent_ids! node.id, if ancestry.nil? then "#{node.id}" else "#{ancestry}/#{node.id}" end
    end
  end

  # a better json output
  def build_json(pretty=true)
    obj = {
      :geoplanet_place => {
        :name => self.name,
        :woeid => self.woeid,
        :country_code => self.country_code,
        :ancestry => self.ancestry,
        :bounding_box => self.bounding_box,
        :place_type => self.place_type
      }
    }
    if pretty
      JSON.pretty_generate(obj)
    else
      JSON.fast_generate(obj)
    end
  end
  
end
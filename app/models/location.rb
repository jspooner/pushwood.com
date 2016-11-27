require 'open-uri'
# SERIALIZED ATTRIBUTES 
# CONSTANTS 
# SCOPES 
# RELATIONSHIPS 
# ATTRIBUTE ACCESSORS 
# GEM CONFIGURATIONS E.G., ACTS_AS_AUTHENTIC 
# VALIDATIONS AND CALLBACKS 
# CLASS METHODS 
# INSTANCE METHODS 
# PROTECTED/PRIVATE METHODS 

class Location < ActiveRecord::Base
  include Acts::Elo
  
  concerned_with :search, :googlemap
  # SERIALIZED ATTRIBUTES 
  # CONSTANTS 
  # SCOPES
  scope :verified, where("marker_verified = true")
  # RELATIONSHIPS 
  belongs_to :cd_page
  belongs_to :user
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :reject_if => lambda { |a| a[:img].blank? }, :allow_destroy => true
  # ATTRIBUTE ACCESSORS 
  # GEM CONFIGURATIONS E.G., ACTS_AS_AUTHENTIC 
  acts_as_elo
  versioned
  acts_as_commentable
  ajaxful_rateable :stars => 5, :dimensions => [:overall, :street, :bowls, :vert, :miniramps], :cache_column => :rating_average
  geocoded_by :address_from_components
  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.address = geo.address
      obj.street  = geo.address(:street)
      # obj.street  = geo.address_components_of_type(:street_number)
      obj.state   = geo.state
      obj.city    = geo.city
      obj.postal  = geo.postal_code
      obj.country = geo.country_code
    end
  end
  include Redis::Objects
  counter :marker_yes
  counter :marker_no
  list :marker_contributors
  
  # VALIDATIONS AND CALLBACKS 
  validates_presence_of :name
  # after_validation :reverse_geocode, :geocode, :if => lambda{ |obj| obj.new_record? }
  after_validation :reverse_geocode, :geocode, :if => lambda{ |obj| Location.should_geocode?(obj) }
  
  # CLASS METHODS 
  def self.build_json(list)
    a = []
    list.each do |item|
      # Hack to get the location node back
      a << '{"location":'+item.to_json(self.api_json_options)+"}"
    end
    "[#{a.join(',')}]"
  end

  def self.api_json_options
    {:methods => [:googlemapurl, :lat, :lng], :except => [:created_at]}
  end
  
  def self.build_images_json(list)
    a = []
    list.each do |trick|
      a << [trick.image.url(:mobile)]
    end
    a.to_json
  end

  def self.should_geocode?(obj)
    if obj.new_record?
      return true
    else
      # if obj.address.blank? or (obj.street.blank? and obj.city.blank? and obj.state.blank? and obj.postal.blank?)
      if (obj.street.blank? and obj.city.blank? and obj.state.blank? and obj.postal.blank?)
        return true
      end
    end
    false
  end
  
  # a string of the form "lat_lo,lng_lo,lat_hi,lng_hi" for this bounds, 
  # where "lo" corresponds to the southwest corner of the bounding box, while "hi" corresponds to the northeast corner of that box.
  def self.in_bounds(bounds)
    _bounds = bounds.flatten
    lat_lo = _bounds[0].to_f
    lng_lo = _bounds[1].to_f
    lat_hi = _bounds[2].to_f
    lng_hi = _bounds[3].to_f
    where("lat >= ? AND lat <= ? AND lng >= ? AND lng <= ? ", lat_lo, lat_hi, lng_lo, lng_hi )
  end

  def self.find_duplicate_locations
    duplicates = []
    Location.find_each(:batch_size => 10) do |location|
      results = location.find_duplicate_locations
      if results.length > 1
        duplicates << results
        logger.info { "Probably some dups here for #{results.first.name} #{results.first.id} - #{results.collect { |l| l.id }.join(", ")}" }
      end
    end
    
    duplicates
  end
  
  def self.recent_verified_markers
    list_length = $redis.llen "recent_verified_markers"
    $redis.lrange "recent_verified_markers", 0, list_length
  end

  def self.recent_marker_votes
    list_length = $redis.llen "recent_marker_votes"
    $redis.lrange "recent_marker_votes", 0, list_length
  end
  
  # INSTANCE METHODS
  def verify_marker(vote, user_id)
    logger.info { "#{vote},#{user_id}" }
    # return {:status => false, :message => "You already voted on this location."} if marker_contributors.include? user_id.to_s
    marker_contributors << { user:user_id, vote:vote}.to_json
    marker_yes.increment if vote == "yes"
    marker_no.increment if vote == "no"
    $redis.lpush "recent_marker_votes", {:location_id => self.id, :verified_at => DateTime.now.to_s}.to_json
    update_marker_verification(user_id)
    {:status => true, :message => "Thank you for voting!"}
  end
  
  def update_marker_verification(user_id)
    if marker_yes.value >= 3 and marker_no.value == 0
      self.update_attribute :marker_verified, true
      $redis.lpush "recent_verified_markers", {:location_id => self.id, :verified_at => DateTime.now.to_s}.to_json
      return
    end
    # 
    if marker_no.value >= 3 and marker_yes.value == 0
      logger.info { "Location #{id} should be reviewed for deletion.  It has #{marker_yes.value} yes votes and #{marker_no.value} no votes" }
      return
    end
    # mixed votes
    if marker_no.value >= 3 and marker_yes.value >= 3
      logger.info { "WTF Location #{id} has #{marker_yes.value} yes votes and #{marker_no.value} no votes" }
      return
    end
  end
  
  # PROTECTED/PRIVATE METHODS 
  # def within(bounding_box)
  #   where("lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", bounding_box['sw']['lat'], bounding_box['ne']['lat'], bounding_box['ne']['lng'], bounding_box['sw']['lng'])
  # end
  
  def address_from_components
    [street, city, state, country].compact.join(', ')
  end
    
  # Help out RestKit by keeping out nulls
  def hours
    self[:hours] || "unknown"
  end
  
  def build_json
    to_json(self.api_json_options)
  end
    
  def ios_description
    return "No description yet.  Please submit one." if read_attribute(:description).nil? or read_attribute(:description).empty?
    read_attribute(:description).gsub(/<\/?[^>]*>/, "")
  end
  
  def to_param
    return "#{id}-#{name.parameterize}" if name
    id
  end
  
  def find_duplicate_locations
    Location.near([self.lat, self.lng], 0.1)
  end
  
end
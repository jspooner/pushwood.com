class Location < ActiveRecord::Base
  
  belongs_to :cd_page  
  validates_uniqueness_of :name
    
  geocoded_by :address_from_components
  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      # puts geo.inspect
      obj.street  = geo.address(:street) #_components_of_type(:street_number)
      obj.state   = geo.state
      obj.city    = geo.city
      obj.postal  = geo.postal_code
      obj.country = geo.country_code
    end
  end
  # after_validation :reverse_geocode, :geocode, :if => lambda{ |obj| obj.new_record? }
  after_validation :reverse_geocode, :geocode, :if => lambda{ |obj| Location.should_geocode?(obj) }

  def address_from_components
    [street, city, state, country].compact.join(', ')
  end
  
  def self.should_geocode?(obj)
    if obj.new_record?
      return true
    else
      if obj.street.blank? and obj.city.blank? and obj.state.blank? and obj.postal.blank?
        return true
      end
    end
    false
  end
  
  # def within(bounding_box)
  #   where("lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", bounding_box['sw']['lat'], bounding_box['ne']['lat'], bounding_box['ne']['lng'], bounding_box['sw']['lng'])
  # end
  
  # a string of the form "lat_lo,lng_lo,lat_hi,lng_hi" for this bounds, 
  # where "lo" corresponds to the southwest corner of the bounding box, while "hi" corresponds to the northeast corner of that box.
  def self.in_bounds(bounds)
    _bounds = bounds.split(",")
    lat_lo = _bounds[0]
    lng_lo = _bounds[1]
    lat_hi = _bounds[2]
    lng_hi = _bounds[3]
    where("lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", lat_lo, lat_hi, lng_lo, lng_hi )
  end
  
  
  # named_scope tricks
  def tricks
    return [] if bounding_box.nil?
    @tricks ||= Trick.all :conditions => ["lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", bounding_box['sw']['lat'], bounding_box['ne']['lat'], bounding_box['ne']['lng'], bounding_box['sw']['lng'] ]
  end
  
  # def lat
  #   bounding_box['sw']['lat'].to_f# + (bounding_box['ne']['lat'].to_f-bounding_box['sw']['lat'].to_f)
  # end
  # 
  # def lng
  #   bounding_box['ne']['lng']
  # end
  
  def googlemapurl
    "http://maps.google.com/maps?ll=#{lat},#{lng}&z=21&t=h"
  end
  
  def bounding_box
    # @josn ||= JSON.parse( self.read_attribute(:bounding_box) )
    ""
  end
  
  def build_json
    to_json(self.api_json_options)
  end
  
  def self.build_json(list)
    a = []
    list.each do |item|
      a << item.to_json(self.api_json_options)
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
  
end

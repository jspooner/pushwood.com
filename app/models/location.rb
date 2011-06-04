class Location < ActiveRecord::Base
  
  belongs_to :cd_page
  
  validates_uniqueness_of :name
    
  geocoded_by :address_from_components
  after_validation :geocode          # auto-fetch coordinates
  
  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.street  = geo.address
      obj.state    = geo.state
      obj.city    = geo.city
      obj.postal  = geo.postal_code
      obj.country = geo.country_code
    end
  end
  after_validation :reverse_geocode

  def address_from_components
    [street, city, state, country].compact.join(', ')
  end
  
  def within(bounding_box)
    where("lat >= ? AND lat <= ? AND lng <= ? AND lng >= ? ", bounding_box['sw']['lat'], bounding_box['ne']['lat'], bounding_box['ne']['lng'], bounding_box['sw']['lng'])
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

require 'nokogiri'
require 'geocoder'

module Pushwood
  # <meta name="description" content="Dreamland  8,000 sq ft; Features: Quarter Pipe, Half Pipe, Bowl, Mini, Vert, Spine, Metal Coping, Rail, Ledge, Outdoor, Lights, Concrete, Skatepark" />
  # <meta name="geo.position" content="44.8398341966;-122.878689766" />
  # <meta name="geo.placename" content="Aumsville, Oregon skatepark" />
  
  class Skaternav < Pushwood::Skatepark
    def initialize(body,doc=nil)
      super(body,doc)
    end
    
    # def full_address
    #   @full_address ||= @doc.css("#toAddress").first['value'] rescue nil
    # end
    # 
    # def geocode_it
    #   return if full_address.nil?
    #   @lat, @lng = Geocoder.coordinates(full_address)
    # end
    
  end
end

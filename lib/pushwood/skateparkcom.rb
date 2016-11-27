require 'nokogiri'
require 'geocoder'

module Pushwood
  class Skateparkcom < Pushwood::Skatepark
    def initialize(body,doc=nil)
      super(body,doc)
      
    end
    
    def full_address
      @full_address ||= @doc.css("#toAddress").first['value'] rescue nil
    end
    
    def geocode_it
      return if full_address.nil?
      @lat, @lng = Geocoder.coordinates(full_address)
    end
    
  end
end

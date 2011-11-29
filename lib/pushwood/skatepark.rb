require 'iconv'
module Pushwood
  class Skatepark
    attr_reader :title, :phone, :hours, :full_address, :street, :postal, :city, :state, :country, :description, :lat, :lng,
                # skate info
                :free, :pads, :supervised, :lights,
                # riding surface
                :outdoors, :concreate, :wood, :metal, :prefab, 
                # obsticles
                :street, :miniramp, :snakerun, :bowl, :vert,
                # page info
                :links, :meta, :images

    def initialize(body,doc=nil)
      ic       = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      utf_body = ic.iconv(body + ' ')[0..-2]
      
      @body    = utf_body
      @doc     = doc || Nokogiri::XML( @body )
      @title   = @doc.css("title").text
      # google_maps_lat_lng
    end
    
    def phone
      @body.match(/\(?\b([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\b/).to_s
    rescue => e
      puts "phone #{e}"
    end

    def google_maps_lat_lng
      @body.match(/new GLatLng\((?<lat>[-0-9.]+)[,\s]+(?<lng>[-0-9.]+)\)/) do |match|
        @lat = match[:lat]
        @lng = match[:lng]
      end
      
      return unless @lat.nil? and @lng.nil?
      
      @body.match(/LatLng\((?<lat>[-0-9.]+)[,\s]+(?<lng>[-0-9.]+)\)/) do |match|
        p match
        @lat = match[:lat]
        @lng = match[:lng]
      end
    end

  end
end

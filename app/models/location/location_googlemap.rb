class Location < ActiveRecord::Base
  
  after_update :update_map
  
  def update_map
    return if lat == 0 or lng == 0
    GoogleMapWorker.perform_async(self.id, true) if self.lat_changed? or self.lng_changed?
  end
  
  def googlemapurl
    "http://maps.google.com/maps?q=#{lat},#{lng}&z=19&t=h"
  end
  
  def google_staticmap
    if google_staticmap?
      "http://#{Rails.configuration.action_mailer['default_url_options'][:host]}/system/staticmaps/#{id}.jpg"
    else
      "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lng}&zoom=20&size=528x400&maptype=hybrid&markers=color:blue|label:A|#{lat},#{lng}&sensor=false"
    end
  end
  
  def google_staticmap?
    File.exists?("#{google_staticmap_dir}#{id}.jpg") and File.exists?("#{google_staticmap_dir}#{id}_ios.jpg") 
  end
  
  def google_staticmap_dir; Rails.root + "public/system/staticmaps/"; end
  
  def cache_google_staticmap
    tries = 0
    begin
      tries += 1
      remove_google_staticmap if google_staticmap?
      FileUtils.mkdir_p google_staticmap_dir
      key = "AIzaSyCxfxVj4y24ZSSnJUvic6_n_48qZEyw4Cs"
      map_url = "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lng}&zoom=20&size=528x400&maptype=hybrid&sensor=false&key=#{key}"
      open(Rails.root + "public/system/staticmaps/#{id}.jpg", 'wb') { |file| file << open(URI.escape(map_url)).read }
      
      map_url = "http://maps.google.com/maps/api/staticmap?center=#{lat},#{lng}&zoom=19&size=528x400&maptype=hybrid&scale=2&sensor=false&key=#{key}"
      open(Rails.root + "public/system/staticmaps/#{id}_ios.jpg", 'wb') { |file| file << open(URI.escape(map_url)).read }
    
      true
    rescue => e
      logger.error { "[ERROR] Location.cache_google_staticmap #{e}" }
      if e.to_s == "403 Forbidden"
        remove_google_staticmap
        logger.error { "sleeping on error" }
        sleep 5
        retry if tries < 3
      end
      
      false
    end
  end
  
  def remove_google_staticmap
    File.delete(Rails.root + "public/system/staticmaps/#{id}.jpg") rescue nil
  end
  
end
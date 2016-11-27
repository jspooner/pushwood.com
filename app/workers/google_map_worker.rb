class GoogleMapWorker
  include Sidekiq::Worker
  # location_id
  # force  force the map location to update
  def perform(location_id, force=false)
    sleep 1
    location = Location.find location_id
    location.cache_google_staticmap if force or !location.google_staticmap?
  end
end
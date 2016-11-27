object @location
attributes :id,  :city, :street, :state, :postal, :country, :description
attributes :name, :hours, :phone, :updated_at
attributes :lng, :lat, :bearing, :googlemapurl, :distance
attributes :pads_required, :is_outdoors, :has_concrete, :has_wood, :has_lights, :is_free

code :url do |m|
  location_url(m)
end

code :address do |m|
  "#{m.street} #{m.city}, #{m.state}".strip
end

code :thumbnail do |m|
  if m.images.approved.empty?
    (m.google_staticmap?) ? m.google_staticmap : "http://#{Rails.configuration.action_mailer['default_url_options'][:host]}" + "/images/ios-default-thumbnail.gif"
  else
    "http://#{request.env['HTTP_HOST']}" + m.images.approved.first.img.url(:iosThumbnail)
  end
end

code :id do |m|
  "#{m[:id]}"
end
code :rate_average do |m|
  m.rate_average
end

node(:images) do |m|
  m.images.approved.collect { |i| {:id => i.id, :credit => i.user.try(:full_name)} }
end
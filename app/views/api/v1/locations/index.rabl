collection @locations
attributes :id,  :city, :street, :state, :postal, :country
attributes :name, :hours, :phone, :updated_at
attributes :lng, :lat, :bearing, :googlemapurl, :distance
attributes :pads_required, :is_outdoors, :has_concrete, :has_wood, :has_lights, :is_free

code :address do |m|
  "#{m.street} #{m.city}, #{m.state}".strip
end

code :description do |m|
  m.ios_description
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
code(:distance) { |val| (val)? "1":"0" }
code(:image_count) { |m| m.images.approved.count }
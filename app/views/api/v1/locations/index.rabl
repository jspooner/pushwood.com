collection @locations
attributes :id,  :city, :street, :state, :postal, :country, :address
attributes :name, :hours, :phone, :updated_at
attributes :lng, :lat, :bearing, :googlemapurl, :distance
attributes :pads_required, :is_outdoors, :has_concrete, :has_wood, :has_lights, :is_free

code :description do |m|
  m.ios_description
end

code :thumbnail do |m|
  if m.images.approved.empty?
    "http://maps.google.com/maps/api/staticmap?center=#{m.lat},#{m.lng}&zoom=20&size=528x400&maptype=hybrid&markers=color:blue|label:A|#{m.lat},#{m.lng}&sensor=false"
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
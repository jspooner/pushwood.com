collection @locations
attributes  :city, :street, :state, :postal, :country, :address
attributes :name, :description, :hours, :phone, :updated_at
attributes :lng, :lat, :bearing, :googlemapurl, :distance
attributes :pads_required, :is_outdoors, :has_concrete, :has_wood, :has_lights, :is_free

code :thumbnail do |m|
  if m.images.empty?
    "http://#{request.env['HTTP_HOST']}/images/BTail.png"
  else
    "http://#{request.env['HTTP_HOST']}" + m.images.first.img.url(:iosThumbnail)
  end
end

code :id do |m|
  "#{m[:id]}"
end
code :rate_average do |m|
  m.rate_average
end
node(:distance) { |val| (val)? "1":"0" }
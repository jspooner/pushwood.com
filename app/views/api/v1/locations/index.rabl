collection @locations
attributes  :city, :street, :state, :postal, :country
attributes :name, :description, :hours, :phone, :updated_at
attributes :lng, :lat, :bearing, :googlemapurl, :distance
attributes :pads_required, :is_outdoors, :has_concrete, :has_wood, :has_lights, :is_free


code :id do |m|
  "#{m[:id]}"
end
code :rate_average do |m|
  m.rate_average
end
node(:distance) { |val| (val)? "1":"0" }
# node(:pads_required) { |val| (val)? "1":"0" }
# node(:is_outdoors) { |val| (val)? "1":"0" }
# node(:has_concrete) { |val| (val)? "1":"0" }
# node(:has_wood) { |val| (val)? "1":"0" }
# node(:has_lights) { |val| (val)? "1":"0" }
# node(:is_free) { |val| (val)? "1":"0" }




















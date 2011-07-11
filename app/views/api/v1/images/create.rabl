object @image
attributes :img_file_name, :img_content_type, :created_at

code :location_id do |m|
  "#{m[:location_id]}"
end

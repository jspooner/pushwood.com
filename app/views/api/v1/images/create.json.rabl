object @image
attributes :img_file_name, :img_content_type, :created_at

code :location_id do |m|
  "#{m[:location_id]}"
end

code :thumbnail do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosSmall)
end
code :large do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosLarge)
end
code :medium do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosMedium) 
end
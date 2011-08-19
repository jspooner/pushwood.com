collection @images
#attributes :id
code :id do |m|
  "#{m.id}"
end
code :thumbnail do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosThumbnail)
end
code :large do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosLarge)
end
code :medium do |m|
    "http://#{request.env['HTTP_HOST']}" + m.img.url(:iosSmall)
end
# code :tiny do |m|
#     "http://#{request.env['HTTP_HOST']}" + m.img.url(:tiny)
# end
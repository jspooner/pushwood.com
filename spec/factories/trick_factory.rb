# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :trick do |f|
  f.user_id 1
  f.image_file_name "MyString"
  f.image_content_type "MyString"
  f.image_file_size 1
  f.image_updated_at "2011-02-18 23:43:02"
  f.lat "MyString"
  f.lng "MyString"
end

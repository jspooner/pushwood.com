# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do |f|
    f.img {spec_file_upload 'large.jpg', 'image/jpeg'}
  end
end

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do |f|
    f.user_id 1
    f.provider "Facebook"
    f.uid "MyString"
  end
end

FactoryGirl.define do
  # This will guess the User class
  factory :user do |user|
    sequence(:last_name) {|n| "Smith #{n}" }
    sequence(:email) {|n| "john.smith.#{n}@example.com" }
    password '111111'
    password_confirmation '111111'
  end
  
  factory :user_photo, :parent => :user do |user|
    after_create { |u| u.roles << FactoryGirl.single_instance(:role_photo) }
  end
  factory :user_no_photo, :parent => :user do |user|
    after_create { |u| u.roles.delete_if { |r| role.name == "photo" } }
  end
  factory :user_admin, :parent => :user do |user|
    sequence(:email) {|n| "admin.#{n}@gmail.com" }
    after_create { |u| u.roles << FactoryGirl.single_instance(:role_admin) }
  end
  
end
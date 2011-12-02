FactoryGirl.define do
  # This will guess the User class
  factory :user do |user|
    sequence(:last_name) {|n| "Smith #{n}" }
    sequence(:email) {|n| "john.smith.#{n}@example.com" }
    password '111111'
    password_confirmation '111111'
  end
  
  
  #
  # Administrators
  #
  factory :admin_user, :parent => :user do |user|
    sequence(:email) {|n| "admin.#{n}@active.com" }
    after_create { |u| u.roles << FactoryGirl.single_instance(:role_admin) }
  end
  
end
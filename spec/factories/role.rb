FactoryGirl.define do
  # This will guess the Event class
  
  factory :role_admin, :class => Role do
    name "admin"
  end
  factory :role_photo, :class => Role do
    name "photo"
  end
  
end

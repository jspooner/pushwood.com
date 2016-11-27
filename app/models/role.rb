class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  scope :assignable_roles, where("name = 'photo' OR name = 'photoadmin' OR name = 'admin'")  
end

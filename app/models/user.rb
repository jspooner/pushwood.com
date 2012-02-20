class User < ActiveRecord::Base
  has_many :authentications
  has_many :rates
  has_many :images
  has_and_belongs_to_many :roles
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  
  before_save :ensure_authentication_token!
  after_create :add_default_roles
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :last_name, :first_name, :authentication_token, :remember_me, :role_ids
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def ensure_authentication_token!
    reset_authentication_token! if authentication_token.blank?
  end  
  
  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  def add_default_roles
    self.roles << Role.find_by_name("photo") unless self.role?(:photo)
  end
  
end

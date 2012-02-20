class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    can :read, :all
    
    unless user.new_record?
      can :rate, Location
      can :update, Location
      can :create, Location
    end
    
    if user.role?(:photo)
      can :create, Image
      can [:update, :destroy], Image do |image|
        image.user == user
      end
    end
    
    if user.role?(:admin)
      can :manage, :all
      can :revert, Location
    end

  end

end

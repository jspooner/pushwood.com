class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)
    # ADMIN
    if user.email == "jspooner@gmail.com" or user.email == "andy@pushwood.com" or user.email == "andy@andymacdonald.com"
      can :revert, Location
      can :manage, Location
    end
    # END ADMIN    
    # EVERYONE
    can :read, Location # user can read any object
    can :read, Rate     # user can read any object
    can :read, Image     # user can read any object
    
    unless user.new_record?
      can :rate, Location
      can :update, Location
      can :create, Location
    end
    
    if user.role? :photo
      can :manage, Image do |image|
        image.user == user
      end
    end


  end

end

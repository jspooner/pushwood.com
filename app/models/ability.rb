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
    
    # EVERYONE
    can :read, Location       # user can read any object
    can :read, Rate       # user can read any object
    
    unless user.new_record?
      can :rate, :location
    end
    
    if user.email == "jspooner@gmail.com" or user.email == "chris.r.gonzales@gmail.com"
      can :manage, Location
    end
    
    
    # # LOGGED IN USER
    #    unless user.new_record?
    #      can :create, AccessRequest
    #      can [:create, :read], Flag
    #      can :read, AccessRequest do |access_request|
    #        access_request.try(:user) == user
    #      end
    #      can :update, User do |u|
    #        user == u
    #      end
    #      can :change_owner, Event do |u|
    #        owner == u
    #      end
    #    end
    # 
    #    if user.role? :approved
    #      can :see_dashboard, User
    #      can :manage, Event do |event|
    #        event.try(:owner) == user
    #      end
    #      can :manage, SubEvent do |sub_event|
    #        sub_event.event.try(:owner) == user
    #      end
    #      can :manage, Upload
    #    end
    #    
    #    if user.role? :organizer
    #      # TODO can search and claim for events
    #    end 
    #    
    #    if user.role?(:admin) or user.role?(:root)
    #      can :manage, :all
    #    end    
    
  end
  
end

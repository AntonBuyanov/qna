class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can [:update, :destroy], [Question, Answer], author_id: user.id
    can :set_best, Answer, author_id: user.id
    can :destroy, Link, linkable: { author_id: user.id }
    can :destroy, Subscription, user_id: user.id
    can :comment, [Question, Answer]
    can [:like, :dislike, :cancel], [Question, Answer] do |votable|
      votable.author_id != user.id
    end
  end
end

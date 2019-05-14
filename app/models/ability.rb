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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer], author_id: user.id
    can :me, User, id: user.id

    can :assigning_as_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end

    can [:create_like, :create_dislike, :delete_vote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can :destroy, Link do |resource|
      user.author_of?(resource.linkable)
    end
  end
end

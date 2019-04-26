module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :delete_all, as: :voteable
  end

  def like(user)
    change_rating(user, 1)
  end

  def dislike(user)
    change_rating(user, -1)
  end

  def deselecting(user)
    if user.voted?(self) && !user.author_of?(self)
      votes.find_by(user_id: user.id).delete
    end
  end

  def choice
    votes.sum(:choice)
  end

  private

  def change_rating(user, option)
    if !user.voted?(self) && !user.author_of?(self)
      votes.create(choice: option, user_id: user.id)
    end
  end
end

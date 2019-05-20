class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :user, :question, presence: true
end

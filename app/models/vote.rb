class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :choice, presence: true
  validates :choice, inclusion: (-1..1)

  validates :user_id, uniqueness: { scope: [:voteable_type, :voteable_id] }
end

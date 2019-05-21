class Question < ApplicationRecord
  include Voteable
  include Commentable

  scope :for_day, -> { where(created_at: Date.today.all_day) }

  after_create_commit :broadcast_question
  after_create :calculate_reputation
  after_create { subscribe(author) }

  has_many :links, dependent: :delete_all, as: :linkable
  has_many :answers, dependent: :delete_all
  has_many_attached :files
  has_one :award, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def broadcast_question
    ActionCable.server.broadcast 'questions', data: self
  end

  def subscribe(user)
    subscriptions.create(user: user) unless subscribed?(user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user).destroy if subscribed?(user)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end

class Question < ApplicationRecord
  include Voteable
  include Commentable

  scope :for_day, -> { where(created_at: Date.today.all_day) }

  after_create_commit :broadcast_question
  after_create :calculate_reputation

  has_many :links, dependent: :delete_all, as: :linkable
  has_many :answers, dependent: :delete_all
  has_many_attached :files
  has_one :award, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def broadcast_question
    ActionCable.server.broadcast 'questions', data: self
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end

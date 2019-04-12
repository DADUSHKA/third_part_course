class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many_attached :files

  validates :body, presence: true

  def assign_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end

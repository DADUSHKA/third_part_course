class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def assigning_best_answer
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end

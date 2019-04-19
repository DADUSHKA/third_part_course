class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many_attached :files
  has_many :links, dependent: :delete_all, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def assign_best
    transaction do
      author.awards << question.award if question.award.present?
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end

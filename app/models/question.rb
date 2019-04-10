class Question < ApplicationRecord
  has_many :answers, dependent: :delete_all
  has_many_attached :files

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
end

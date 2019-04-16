class Question < ApplicationRecord
  has_many :links, dependent: :delete_all, as: :linkable
  has_many :answers, dependent: :delete_all
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
end

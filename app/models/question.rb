class Question < ApplicationRecord
  include Voteable

  has_many :links, dependent: :delete_all, as: :linkable
  has_many :answers, dependent: :delete_all
  has_many_attached :files
  has_one :award, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
end

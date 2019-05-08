class Answer < ApplicationRecord
  include Voteable
  include Commentable

  default_scope { order(best: :desc) }

  after_create_commit :broadcast_answer

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

  private

  def broadcast_answer
     ActionCable.server.broadcast "question/#{question.id}/answers", data: answer_data
  end

  def files_data
    data =[]
    files.each do |file|
      data << {
        file_name: file.filename.to_s,
        file_id: file.id,
        file_url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end

    data
  end

  def links_data
    links_data = []
    links.each { |link| links_data << { link_name: link.name, link_url: link.url } }
    links_data
  end

  def answer_data
    data = {}
    data[:answer] = self
    data[:files] = files_data
    data[:links] = links_data
    data[:vote] = choice

    data
  end
end

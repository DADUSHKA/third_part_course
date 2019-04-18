class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, :url => true

  def to_gist?
    url.match?(/https:\/\/gist.github.com\/\w+\//)
  end
end

module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :delete_all, as: :voteable
  end

end

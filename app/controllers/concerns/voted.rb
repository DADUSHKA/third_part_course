module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[create_like create_dislike delete_vote]
  end

  def create_like
    @voteable.like(current_user)
  end

  def create_dislike
    @voteable.dislike(current_user)
  end

  def delete_vote
    @voteable.deselecting(current_user)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end

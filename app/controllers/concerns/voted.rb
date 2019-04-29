module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[create_like create_dislike delete_vote]
  end

  def create_like
    render_json if @voteable.like(current_user)
  end

  def create_dislike
    render_json if @voteable.dislike(current_user)
  end

  def delete_vote
    render_json if @voteable.deselecting(current_user)
  end

  private

  def render_json
    render json: { choice: @voteable.choice, id: @voteable.id, klass: @voteable.class.to_s }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end

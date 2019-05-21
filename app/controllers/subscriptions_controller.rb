class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @question.subscribe(current_user)

    redirect_to question_path(@question), notice: 'You subscribed.'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.question.unsubscribe(@subscription.user)

    redirect_to question_path(@subscription.question), notice: 'You unsubscribed.'
  end
end

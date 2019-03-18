class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user
      @answer.destroy

    else
      flash[:error] = 'Cannot delete the answer'
    end

    redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

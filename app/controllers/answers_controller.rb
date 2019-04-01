class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    flash[:notice] = 'Your answer successfully created.' if @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)

    redirect_to question_path(@answer.question), notice: 'Answer was successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

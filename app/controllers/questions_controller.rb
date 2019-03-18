class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @question = question
  end

  def new; end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
     redirect_to @question
      else
     render :edit
    end
  end

  def destroy
    if current_user
      question.destroy
      redirect_to questions_path
      flash[:notice] = 'Question was successfully deleted'
    else
      redirect_to @question
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.build
    @answer.links.new
    @question = question
    gon.current_user = current_user
    gon.question = question
    gon.question_id = question.id
  end

  def new
    question.links.build
    question.build_award
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
    flash.now[:notice] = "The question was updated successfully."
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: "Question was successfully deleted"
    else
      redirect_to @question
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
     links_attributes: [:id, :_destroy, :name, :url],
     award_attributes: [:name, :image])
  end
end

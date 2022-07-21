class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_question, only: %i[show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question was created successfully'
    else
      render :new
    end
  end

  def show;
  end

  # def update
  #   if @question.update(question_params)
  #     redirect_to @question
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @question.destroy
  #   redirect_to questions_path
  # end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end

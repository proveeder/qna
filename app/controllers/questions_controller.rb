class QuestionsController < ApplicationController
  # before_action :set_question, only: %i[show edit update destroy]

  # def index
  #   @questions = Question.all
  # end
  #
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      # TODO: change redirect and update test
      nil
      # redirect_to @question
    else
      # TODO: change redirect and update test
      nil
      # render :new
    end
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

  # def set_question
  #   @question = Question.find(params[:id])
  # end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end

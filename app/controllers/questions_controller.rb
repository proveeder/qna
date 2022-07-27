class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy update]
  before_action :set_question, only: %i[show delete destroy update]

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

  def show; end

  def update
    if @question.user == current_user
      @question.title = question_params[:title]
      @question.body = question_params[:body].strip # required for jquery to be able to display it correctly
      @question.save
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path, notice: 'You deleted question successfully'
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end

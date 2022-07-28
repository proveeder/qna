class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy update set_best_answer]
  before_action :set_question, only: %i[show delete destroy update set_best_answer]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
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

  def show
    @best_answer = Answer.find(@question.best_answer_id) unless @question.best_answer_id.nil?
  end

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

  def set_best_answer
    if @question.user == current_user
      @best_answer = Answer.find(params[:best_answer_id])
      @question.best_answer_id = @best_answer.id
      @question.save
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, attachments_attributes: [:file])
  end
end

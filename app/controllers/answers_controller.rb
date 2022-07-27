class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_answer, only: %i[update destroy]

  def create
    @answer = Answer.create(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    @answer.save
    @question = @answer.question
  end

  def update
    if @answer.user == current_user
      @answer.update(answer_params)
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end

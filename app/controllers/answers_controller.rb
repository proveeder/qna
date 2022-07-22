class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    @answer = Answer.create(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user
    if @answer.save
      redirect_to @answer.question, notice: 'Thanks for your answer!'
    else
      redirect_to @answer.question, notice: 'You must enter text of your answer'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.destroy
      redirect_to @answer.question, notice: 'You deleted your answer for this question'
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

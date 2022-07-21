class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @answer = Answer.create(answer_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      redirect_to @answer.question, notice: 'Thanks for your answer!'
    else
      redirect_to @answer.question, notice: 'You must enter text of your answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

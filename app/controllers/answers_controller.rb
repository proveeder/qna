class AnswersController < ApplicationController
  def create
    @answer = Answer.create(answer_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      # TODO: redirect
      nil
    else
      # TODO: redirect
      nil
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end

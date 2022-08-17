class Api::V1::AnswersController < Api::V1::BaseController
  def index
    respond_with Question.find(params[:question_id])
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @answer = Answer.new(question_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      render status: 200
    else
      render json: @answer.errors
    end
  end

  private

  def question_params
    params.require(:answer).permit(:body, :user_id)
  end
end


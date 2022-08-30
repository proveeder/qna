class Api::V1::AnswersController < Api::V1::BaseController
  def index
    respond_with Question.find(params[:question_id])
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    authorize! :create, Answer
    @answer = Answer.new(question_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      render json: :ok
    else
      render json: @answer.errors, status: 500
    end
  end

  private

  def question_params
    params.require(:answer).permit(:body, :user_id)
  end
end


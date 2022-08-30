class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    authorize! :create, Question
    @question = Question.new(question_params)
    if @question.save
      render json: :ok
    else
      render json: @question.errors, status: 500
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end

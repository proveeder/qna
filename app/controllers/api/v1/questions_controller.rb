class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      render status: 200
    else
      render json: @question.errors
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end

class AnswersController < ApplicationController

  before_action :authenticate_user!, only: %i[create destroy vote_for_answer]
  before_action :set_answer, only: %i[update destroy vote_for_answer]

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

  def vote_for_answer
    unless @answer.user == current_user
      @record = UserAnswerVote.find_or_create_by(user_id: current_user.id, answer_id: params[:id])

      # convert from string to proper bool values
      @record.liked = ActiveModel::Type::Boolean.new.cast(params[:liked])
      @record.disliked = !ActiveModel::Type::Boolean.new.cast(params[:liked])

      respond_to do |format|
        @record.save
        format.json do
          render json: { rating: UserAnswerVote.where(answer_id: @answer,
                                                      liked: true).count - UserAnswerVote.where(answer_id: @answer,
                                                                                                disliked: true).count }
        end
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end

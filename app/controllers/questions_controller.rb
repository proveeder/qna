class QuestionsController < ApplicationController
  skip_before_action :check_email_activation, only: %i[index show]
  before_action :authenticate_user!, only: %i[new create destroy update set_best_answer vote_for_question]
  before_action :set_question, only: %i[show delete destroy update set_best_answer vote_for_question]
  before_action :new_answer, only: %i[show]

  after_action :publish_question, only: %i[create]

  respond_to :html, :javascript, :json

  def index
    respond_with @questions = Question.all
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    flash[:notice] = 'Your question was created successfully' if @question.save
    respond_with @question
  end

  def show
    @best_answer = Answer.find(@question.best_answer_id) unless @question.best_answer_id.nil?
    respond_with @question
  end

  def update
    if @question.user == current_user
      @question.update(question_params)
      @question.body = question_params[:body].strip # required for jquery to be able to display it correctly
      @question.save
      respond_with @question, &:js
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def destroy
    if @question.user == current_user
      respond_with @question.destroy
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def set_best_answer
    if @question.user == current_user
      @best_answer = Answer.find(params[:best_answer_id])
      @question.best_answer_id = @best_answer.id
      respond_with @question.save, &:js
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def vote_for_question
    @record = UserQuestionVote.find_or_create_by(user_id: current_user.id,
                                                 question_id: params[:id])

    # convert from string to proper bool values
    @record.liked = ActiveModel::Type::Boolean.new.cast(params[:liked])
    @record.disliked = !ActiveModel::Type::Boolean.new.cast(params[:liked])

    respond_to do |format|
      @record.save
      format.json do
        render json: { rating:
                         UserQuestionVote.where(question_id: @question,
                                                liked: true).count - UserQuestionVote.where(question_id: @question,
                                                                                            disliked: true).count }
      end
    end
  end

  private

  def new_answer
    @answer = Answer.new
  end

  def publish_question
    unless @question.errors.any?
      ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/question_in_index',
                                                                             locals: { q: @question,
                                                                                       current_user: current_user }))
    end
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, attachments_attributes: [:file, :id])
  end
end

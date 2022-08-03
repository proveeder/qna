class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create destroy update set_best_answer vote_for_question]
  before_action :set_question, only: %i[show delete destroy update set_best_answer vote_for_question]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question was created successfully'
    else
      render :new
    end
  end

  def show
    @best_answer = Answer.find(@question.best_answer_id) unless @question.best_answer_id.nil?
    @answer = Answer.new
    @answer.attachments.build

  end

  def update
    # render partial: 'question'
    if @question.user == current_user
      @question.update(question_params)
      @question.body = question_params[:body].strip # required for jquery to be able to display it correctly
      @question.save
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path, notice: 'You deleted question successfully'
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def set_best_answer
    if @question.user == current_user
      @best_answer = Answer.find(params[:best_answer_id])
      @question.best_answer_id = @best_answer.id
      @question.save
    else
      render status: :forbidden, json: @controller.to_json
    end
  end

  def vote_for_question
    if @question.user == current_user
      render status: :forbidden, json: @controller.to_json
    else
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
  end

  private

  def publish_question
    nil if @question.errors.any?
    ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/question_in_index',
                                                                           locals: { q: @question,
                                                                                     current_user: current_user }))
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, attachments_attributes: [:file, :id])
  end
end

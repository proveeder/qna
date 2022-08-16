class UpdateQuestionNotificationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  authorize_resource

  def create
    subscription = UpdateQuestionNotification.new(user_id: current_user.id, question_id: @question.id)
    if subscription.save
      redirect_to @question, notice: 'You subscribed to this question'
    else
      redirect_to @question, notice: 'Something went wrong'
    end
  end

  def destroy
    subscription = UpdateQuestionNotification.find_by(user_id: current_user, question_id: @question.id)
    flash[:notice] = 'You unsubscribed successfully' if subscription&.destroy
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end

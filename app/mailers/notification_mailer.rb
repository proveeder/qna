class NotificationMailer < ApplicationMailer
  def new_answer_notification
    @question = params[:question]
    @user = @question.user
    mail(to: @user.email, subject: 'New answer!')
  end
end

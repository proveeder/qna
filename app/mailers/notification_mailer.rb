class NotificationMailer < ApplicationMailer
  def new_answer_notification
    @question = params[:question]
    @user = User.find(params[:user_id])
    mail(to: @user.email, subject: 'New answer!')
  end
end

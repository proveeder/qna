class DailyMailer < ApplicationMailer
  def daily_digest
    @user = params[:user]
    @questions = Question.where('created_at >= ?', 1.days.ago)
    mail(to: @user.email, subject: 'Daily digest here!')
  end
end

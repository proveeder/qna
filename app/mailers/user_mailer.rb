class UserMailer < ApplicationMailer
  def update_email
    user.activation_token = Devise.friendly_token[0, 20]
    @url = "#{activate_user_url}?#{{ activation_token: user.activation_token }.to_query}"
    user.save(validate: false)

    mail(to: @user.email, template_path: 'user_mailer/update_email')
  end
end

class UserActivationsController < ApplicationController
  before_action :authenticate_user!

  def change_email
    render 'activations/change_email'
  end

  def update_email
    user = current_user
    p user
    user.email = params[:updated][:email]
    if user.save(validate: false)
      UserMailer.with(user: user).update_email.deliver_later
      flash[:notice] = 'Check your email'
    else
      flash[:notice] = user.errors
    end
    redirect_to root_path
  end

  def activate_user
    if current_user.activation_token == params[:activation_token]
      user.active = true
      user.save(validate: false)
      flash[:notice] = 'You activated your account successfully'
    else
      flash[:notice] = 'Invalid token'
    end
    redirect_to root_path
  end
end

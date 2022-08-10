class UserActivationsController < ApplicationController
  skip_before_action :check_email_activation

  def change_email
    render 'activations/change_email'
  end

  def update_email
    user = current_user
    user.unconfirmed_email = params[:updated][:email]
    user.save
    user.send_confirmation_instructions
    flash[:notice] = 'Check your email'
    redirect_to root_path
  end
end

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check

  def twitter2
    sign_in_with_oauth('Twitter')
  end

  def github
    sign_in_with_oauth('Github')
  end

  private

  def sign_in_with_oauth(provider_name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    p request.env['omniauth.auth'][:info]
    if @user.persisted?
      sign_in @user
      if request.env['omniauth.auth'][:info][:email].nil? && @user.unconfirmed_email&.present?
        flash[:notice] = 'We NEED your email'
        redirect_to change_email_path
      else
        set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
        redirect_to root_path
      end
    else
      flash[:notice] = 'Something went wrong, try again'
      redirect_to new_user_session_path
    end
  end
end

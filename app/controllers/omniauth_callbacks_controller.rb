class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # TODO: delete it
  # render json: request.env['omniauth.auth']

  def twitter2
    sign_in_with_oauth('Twitter')
  end

  def github
    sign_in_with_oauth('Github')
  end

  private

  def sign_in_with_oauth(provider_name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in @user
      if request.env['omniauth.auth'][:info][:email].nil?
        flash[:notice] = 'We NEED your email'
        @user.active == false ? (redirect_to change_email_path) : (redirect_to root_path)
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

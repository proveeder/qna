class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter2
    render json: request.env['omniauth.auth']
    # @user = User.find_for_oauth(request.env['omniauth.auth'])
    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'Twitter2') if is_navigational_format?
    # else
    #   flash[:notice] = 'Something went wrong, try again'
    #   redirect_to new_user_session_path
    # end
  end

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      flash[:notice] = 'Something went wrong, try again'
      redirect_to new_user_session_path
    end
  end
end

module ControllerMacros
  def sign_in_user
    before do
      # devise stuff
      user = create(:user)
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
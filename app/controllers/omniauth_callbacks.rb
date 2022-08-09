class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter2
    p request
  end
end

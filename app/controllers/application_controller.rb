require "application_responder"

class ApplicationController < ActionController::Base
  before_action :check_email_activation

  self.responder = ApplicationResponder
  respond_to :html

  def check_email_activation
    if current_user&.unconfirmed_email&.present?
      flash[:notice] = 'YOU ARE REQUIRED TO PROVIDE VALID EMAIL'
      redirect_to change_email_path
    end
  end
end

class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  before_action :doorkeeper_authorize!

  def me
    head 200, content_type: "text/html"
  end
end

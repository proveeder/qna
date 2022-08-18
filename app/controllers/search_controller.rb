class SearchController < ApplicationController
  skip_authorization_check

  def search
    @result = params[:search_option].constantize.search params[:search_text]
    render 'show'
  end
end

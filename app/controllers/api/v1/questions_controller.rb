class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
    # head 200, content_type: "text/html"
  end
end

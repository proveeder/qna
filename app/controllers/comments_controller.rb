class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.new(comment_params)
    if @comment.save
      redirect_to question_path(params[:question_id])
    else
      redirect_to question_path(params[:question_id]), alert: 'Text of comment is required'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end

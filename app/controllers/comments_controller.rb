class CommentsController < ApplicationController
  def create
    @comment = Comment.create(comment_params)
    p @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text)
  end
end

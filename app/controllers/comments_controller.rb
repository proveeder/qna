class CommentsController < ApplicationController
  after_action :publish_comment, only: %i[create]

  def create
    @comment = Comment.create(comment_params)
  end

  private

  def publish_comment
    unless @comment.errors.any?
      ActionCable.server.broadcast("#{@comment.commentable_type.downcase}_comments", @comment)
    end
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text)
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    ActionCable.server.broadcast("#{@comment.commentable_type.downcase}_comments", @comment) unless @comment.errors.any?
  end

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text)
  end
end

class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment.attachable.user == current_user
      @attachment.destroy
    end
  end
end

class AttachFileController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @obj = @file.record
    @file.purge if current_user.author_of?(@obj)
  end
end

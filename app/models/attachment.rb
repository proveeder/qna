class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FileUploader

  after_destroy :delete_file_directory

  private

  # delete directory where file was uploaded so no trash remain after object been destroyed
  def delete_file_directory
    FileUtils.remove_dir("#{Rails.root}/public/uploads/#{self.class.to_s.underscore}/#{id}")
  end
end

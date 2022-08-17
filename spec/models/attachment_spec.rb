require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }

  describe '.delete_file_directory' do
    let(:attachment) { create(:attachment) }

    it 'deletes file directory' do
      expect(attachment).to receive(:delete_file_directory)
      attachment.destroy!
    end
  end
end

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:update_question_notifications).dependent(:destroy) }

  it { should belong_to(:user) }

  it { should accept_nested_attributes_for(:attachments) }

  it { should_not allow_value('').for(:title) }
  it { should_not allow_value('').for(:body) }

  describe 'subscription' do
    subject { build(:question) }

    it 'should create subscription after creating' do
      expect { subject.save }.to change(UpdateQuestionNotification, :count).by(1)
    end
  end
end

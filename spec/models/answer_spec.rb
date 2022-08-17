require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:attachments) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for(:attachments) }

  it { should_not allow_value('').for(:body) }

  describe 'with real object' do
    subject { build(:answer) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end

  describe 'subscription' do
    let(:subscriptions) { create_list(:update_question_notification, 2, question_id: answer.question.id) }
    let(:answer) { create(:answer) }

    it 'sends notification to all subscribers when answer creates' do
      subscriptions.each do |s|
        allow(NotificationMailer).to receive(:new_answer_notification).with(question: s.question_id,
                                                                             user_id: s.user_id).and_call_original
      end
      answer.send_notification
    end
  end
end

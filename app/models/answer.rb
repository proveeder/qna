class Answer < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  validates :question_id, presence: true
  validates :user_id, presence: true, allow_blank: false,
                      uniqueness: { scope: :question_id }

  belongs_to :question, touch: true
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :send_notification
  after_save ThinkingSphinx::RealTime.callback_for(:answer)
  before_destroy :nullify_best_answer

  def send_notification
    UpdateQuestionNotification.where(question_id: question.id).find_each.each do |subscription|
      NotificationMailer.with(question: question, user_id: subscription.user_id).new_answer_notification.deliver_later
    end
  end

  private

  def nullify_best_answer
    if question.best_answer_id == id
      question.best_answer_id = nil
      question.save
    end
  end
end

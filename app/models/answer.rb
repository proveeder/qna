class Answer < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  validates :question_id, presence: true
  validates :user_id, presence: true, allow_blank: false,
                      uniqueness: { scope: :question_id }

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :send_notification
  before_destroy :nullify_best_answer

  private

  def send_notification
    NotificationMailer.with(question: self.question).new_answer_notification.deliver_later
  end

  def nullify_best_answer
    if question.best_answer_id == id
      question.best_answer_id = nil
      question.save
    end
  end
end

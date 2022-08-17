class Question < ApplicationRecord
  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :update_question_notifications, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe_to_question_updates

  private

  def subscribe_to_question_updates
    subscription = UpdateQuestionNotification.create(user_id: user.id, question_id: self.id)
    subscription.save
  end
end

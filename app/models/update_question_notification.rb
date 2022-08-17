class UpdateQuestionNotification < ApplicationRecord
  validates :user_id, presence: true,
                      uniqueness: { scope: :question_id }
  validates :question_id, presence: true
end

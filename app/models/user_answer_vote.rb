class UserAnswerVote < ApplicationRecord
  validates :user_id, uniqueness: { scope: :answer_id }
end

class UserAnswerVote < ApplicationRecord
  validates :user_id, uniqueness: { scope: :answer_id }

  belongs_to :user
end

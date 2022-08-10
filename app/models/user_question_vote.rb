class UserQuestionVote < ApplicationRecord
  validates :user_id, uniqueness: { scope: :question_id }

  belongs_to :user
end

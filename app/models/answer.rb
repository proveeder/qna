class Answer < ApplicationRecord
  validates :body, presence: true, allow_blank: false
  validates :question_id, presence: true
  validates :user_id, presence: true, allow_blank: false,
            uniqueness: { scope: :question_id }

  belongs_to :question
  belongs_to :user
end

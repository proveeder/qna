class Answer < ApplicationRecord
  validates :body, presence: true
  validates :question_id, presence: true

  belongs_to :question, optional: false
end

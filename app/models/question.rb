class Question < ApplicationRecord
  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  accepts_nested_attributes_for :attachments
end

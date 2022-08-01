class Question < ApplicationRecord
  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end

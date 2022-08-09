class Authorization < ApplicationRecord
  validates :provider, presence: true
  validates :uid, presence: true
  validates :user_id, presence: true

  belongs_to :user
end

class Comment < ApplicationRecord
  validates :text, presence: true
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true

  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  after_save ThinkingSphinx::RealTime.callback_for(:comment)
end

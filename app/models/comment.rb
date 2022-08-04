class Comment < ApplicationRecord
  validates :text, presence: true

  belongs_to :commentable, polymorphic: true
end

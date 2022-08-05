require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :text }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
  it { should belong_to :commentable }
  it { should belong_to :user }
end

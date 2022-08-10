require 'rails_helper'

RSpec.describe UserQuestionVote, type: :model do
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  it { should belong_to(:user) }
end

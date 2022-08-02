require 'rails_helper'

RSpec.describe UserAnswerVote, type: :model do
  it { should validate_uniqueness_of(:user_id).scoped_to(:answer_id) }
end

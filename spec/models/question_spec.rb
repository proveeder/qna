require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should_not allow_value('').for(:title) }
  it { should_not allow_value('').for(:body) }
end

FactoryBot.define do
  factory :comment do
    text { 'Test comment text' }
    commentable_type { 'Answer' }
    commentable_id { create(:answer).id }
    user_id { create(:user).id }
  end
end

FactoryBot.define do
  factory :comment do
    text { 'Test comment text' }
    commentable_type { 'Answer' }
    commentable_id { create(:answer).id }
  end
end

FactoryBot.define do
  factory :update_question_notification do
    user_id { create(:user).id }
    question_id { create(:question).id }
  end
end

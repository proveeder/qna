FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user_id { create(:user).id }
  end

  factory :invalid_question, class: 'Question' do
    title { nil }
    body { nil }
    user { nil }
  end
end

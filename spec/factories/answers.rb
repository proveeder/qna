FactoryBot.define do
  factory :answer do
    body { 'Some answer text' }
    question { create(:question) }
    user { create(:user) }
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
    question { create(:question) }
  end
end

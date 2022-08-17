FactoryBot.define do
  factory :answer do
    body { 'Some answer text' }
    question { create(:question) }
    user { create(:user) }
  end

  factory :answer_with_file, class: 'Answer' do
    body { 'Some answer text' }
    question { create(:question) }
    user { create(:user) }

    after(:create) do |question|
      question.attachments << create(:attachment)
    end
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
    question { create(:question) }
  end
end

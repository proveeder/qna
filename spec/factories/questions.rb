FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    user { create(:user) }
  end

  factory :question_with_file, class: 'Question' do
    title { 'MyString' }
    body { 'MyText' }
    user { create(:user) }

    after(:create) do |question|
      question.attachments << create(:attachment)
    end
  end

  factory :invalid_question, class: 'Question' do
    title { nil }
    body { nil }
    user { nil }
  end
end

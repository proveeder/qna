FactoryBot.define do
  factory :answer do
    body { 'Some answer text' }
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
  end
end

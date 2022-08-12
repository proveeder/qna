FactoryBot.define do
  factory :attachment, class: 'Attachment' do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/answers.rb')) }
    attachable_id { create(:question).id }
    attachable_type { 'Question' }
  end
end

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.org" }
    password { 'MyString' }
  end
end

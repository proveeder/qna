FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.org" }
    password { 'Here_we_have_some_pswd123' }
  end
end

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "#{n}@mail.org"}
    password { 'MyString' }
  end
end

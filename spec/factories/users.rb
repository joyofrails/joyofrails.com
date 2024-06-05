FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "hello#{n}@example.com" }
  end
end

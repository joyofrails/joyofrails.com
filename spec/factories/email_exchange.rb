FactoryBot.define do
  factory :email_exchange do
    sequence(:email) { |n| "email#{n}@example.com" }
    user { nil }
    status { 0 }
  end
end

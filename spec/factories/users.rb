FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "hello#{n}@example.com" }

    password { "password" }
    password_confirmation { "password" }

    trait :unconfirmed

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end

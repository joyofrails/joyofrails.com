FactoryBot.define do
  sequence(:email) { |n| "hello#{n}@example.com" }
end

FactoryBot.define do
  factory :user do
    email

    password { "password" }
    password_confirmation { "password" }

    trait :unconfirmed

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end

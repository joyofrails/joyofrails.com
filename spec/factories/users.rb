FactoryBot.define do
  sequence(:email) { |n| "hello#{n}@example.com" }
end

FactoryBot.define do
  factory :user do
    email

    password { "password" }
    password_confirmation { "password" }

    trait :unconfirmed
    trait :unsubscribed

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :subscribing do
      subscribing { true }
      password { nil }
      password_confirmation { nil }
    end

    trait :subscribed do
      newsletter_subscription
    end
  end
end

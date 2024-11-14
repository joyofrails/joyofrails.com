# == Schema Information
#
# Table name: users
#
#  id              :string           not null, primary key
#  confirmed_at    :datetime
#  email           :string           not null
#  last_sign_in_at :datetime
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
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

    trait :subscriber do
      subscribing
      newsletter_subscription
    end

    trait :subscribed do
      newsletter_subscription
    end
  end
end

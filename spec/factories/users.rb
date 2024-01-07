FactoryBot.define do
  factory :user do
    email { "joy@joyofrails.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.zone.now }

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end

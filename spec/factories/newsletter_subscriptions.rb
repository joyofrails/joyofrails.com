FactoryBot.define do
  factory :newsletter_subscription do
    association :subscriber, factory: :user
  end
end

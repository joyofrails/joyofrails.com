# spec/factories/topics.rb
FactoryBot.define do
  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }

    status { "pending" }

    trait :approved do
      status { "approved" }
    end

    trait :rejected do
      status { "rejected" }
    end

    trait :duplicate do
      status { "duplicate" }
    end
  end
end

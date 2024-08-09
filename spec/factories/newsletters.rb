FactoryBot.define do
  factory :newsletter do
    title { Faker::Lorem.sentence }
    content { Faker::Markdown.sandwich(sentences: 3) }

    trait :sent do
      sent_at { 1.day.ago }
    end
  end
end

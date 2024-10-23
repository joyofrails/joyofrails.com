FactoryBot.define do
  factory :newsletter do
    title { Faker::Lorem.sentence }
    content { Faker::Markdown.sandwich(sentences: 3) }

    trait :sent do
      sent_at { rand(100).to_i.days.ago }
    end
  end
end

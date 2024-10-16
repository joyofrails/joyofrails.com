FactoryBot.define do
  factory :snippet do
    source { "puts \"Hello, world!\"" }
    language { "ruby" }
    filename { "example.rb" }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    author { build(:user) }
  end
end

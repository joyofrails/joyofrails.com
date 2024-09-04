FactoryBot.define do
  factory :snippet do
    source { "puts \"Hello, world!\"" }
    language { "ruby" }
    filename { "example.rb" }
    author { build(:user) }
  end
end

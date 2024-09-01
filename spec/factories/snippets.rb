FactoryBot.define do
  factory :snippet do
    source { "puts \"Hello, world!\"" }
    language { "ruby" }
    author { build(:user) }
  end
end

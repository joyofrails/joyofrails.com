FactoryBot.define do
  factory :snippet do
    source { "puts \"Hello, world!\"" }
    language { "ruby" }
    filename { "example.rb" }
    description { "# Hello World in Ruby" }
    author { build(:user) }
  end
end

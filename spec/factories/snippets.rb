# == Schema Information
#
# Table name: snippets
#
#  id          :string           not null, primary key
#  author_type :string           not null
#  description :text
#  filename    :string
#  language    :string
#  source      :text             not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :string           not null
#
# Indexes
#
#  index_snippets_on_author  (author_type,author_id)
#
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

# == Schema Information
#
# Table name: pages
#
#  id           :string           not null, primary key
#  indexed_at   :datetime
#  published_at :datetime
#  request_path :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_indexed_at    (indexed_at)
#  index_pages_on_published_at  (published_at)
#  index_pages_on_request_path  (request_path) UNIQUE
#
FactoryBot.define do
  factory :page do
    request_path { "/" + Faker::Internet.slug }
  end
end

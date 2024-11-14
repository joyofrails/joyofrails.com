# == Schema Information
#
# Table name: pages
#
#  id           :string           not null, primary key
#  request_path :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_request_path  (request_path) UNIQUE
#
FactoryBot.define do
  factory :page do
    request_path { "/" + Faker::Internet.slug }
  end
end

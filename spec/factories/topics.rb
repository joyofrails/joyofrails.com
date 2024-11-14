# spec/factories/topics.rb
# == Schema Information
#
# Table name: topics
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string
#  pages_count :integer          default(0), not null
#  slug        :string           not null
#  status      :string           default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_topics_on_pages_count  (pages_count)
#  index_topics_on_slug         (slug) UNIQUE
#  index_topics_on_status       (status)
#
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

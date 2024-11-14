# == Schema Information
#
# Table name: newsletters
#
#  id         :string           not null, primary key
#  content    :text             not null
#  sent_at    :datetime
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletters_on_sent_at  (sent_at)
#
FactoryBot.define do
  factory :newsletter do
    title { Faker::Lorem.sentence }
    content { Faker::Markdown.sandwich(sentences: 3) }

    trait :sent do
      sent_at { rand(100).to_i.days.ago }
    end
  end
end

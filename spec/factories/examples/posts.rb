# == Schema Information
#
# Table name: examples_posts
#
#  id            :integer          not null, primary key
#  postable_type :string           not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :integer          not null
#
# Indexes
#
#  index_examples_posts_on_postable  (postable_type,postable_id)
#
FactoryBot.define do
  factory :examples_post, class: "Examples::Post" do
    title { "MyString" }
    postable { nil }
  end
end

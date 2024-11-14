# == Schema Information
#
# Table name: examples_posts_images
#
#  id         :integer          not null, primary key
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :examples_posts_image, class: "Examples::Posts::Image" do
    url { "MyString" }
  end
end

FactoryBot.define do
  factory :examples_post, class: "Examples::Post" do
    title { "MyString" }
    postable { nil }
  end
end

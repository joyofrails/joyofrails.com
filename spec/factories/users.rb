FactoryBot.define do
  factory :user do
    email { |n| "hello#{n}@example.com" }
  end
end

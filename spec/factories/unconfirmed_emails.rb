FactoryBot.define do
  factory :unconfirmed_email do
    email { "MyString" }
    user { nil }
    status { "MyString" }
  end
end

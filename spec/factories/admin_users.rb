FactoryBot.define do
  factory :admin_user do
    email { "joy@joyofrails.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end

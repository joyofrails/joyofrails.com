# == Schema Information
#
# Table name: admin_users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :admin_user do
    email { "joy@joyofrails.com" }
    password { "password" }
    password_confirmation { password }
  end
end

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
require "rails_helper"

RSpec.describe AdminUser, type: :model do
  describe "#save" do
    def create_admin_user!(email:, password: "password", password_confirmation: "password")
      AdminUser.create!(email: email, password: password, password_confirmation: password_confirmation)
    end

    it "saves the admin_user" do
      expect(create_admin_user!(email: "joy@joyofrails.com")).to be_persisted
    end

    it "downcases the email" do
      expect(create_admin_user!(email: "Joy@JoyOfRails.com").email).to eq("joy@joyofrails.com")
    end

    it "validates the email" do
      expect {
        create_admin_user!(email: "JOYOFRAILS.com")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid")
    end

    it "validates the uniqueness of the email" do
      FactoryBot.create(:admin_user, email: "joy@joyofrails.com")
      expect {
        create_admin_user!(email: "joy@joyofrails.com")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
    end
  end
end

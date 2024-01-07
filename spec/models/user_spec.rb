require "rails_helper"

RSpec.describe User, type: :model do
  describe "#save" do
    def create_user!(email:, password: "password", password_confirmation: "password")
      User.create!(email: email, password: password, password_confirmation: password_confirmation)
    end

    it "saves the user" do
      expect(create_user!(email: "joy@joyofrails.com")).to be_persisted
    end

    it "downcases the email" do
      expect(create_user!(email: "Joy@JoyOfRails.com").email).to eq("joy@joyofrails.com")
    end

    it "validates the email" do
      expect {
        create_user!(email: "JOYOFRAILS.com")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email is invalid")
    end

    it "validates the uniqueness of the email" do
      FactoryBot.create(:user, email: "joy@joyofrails.com")
      expect {
        create_user!(email: "joy@joyofrails.com")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Email has already been taken")
    end
  end
end

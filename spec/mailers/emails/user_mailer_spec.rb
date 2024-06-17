require "rails_helper"

RSpec.describe Emails::UserMailer, type: :mailer do
  describe "confirmation" do
    let(:user) { instance_double(User, confirmable_email: "to@example.com") }
    let(:mail) { Emails::UserMailer.confirmation(user, "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your email address")
      expect(mail.to).to eq(["to@example.com"])
      expect(mail.from).to eq(["no-reply@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Confirm your email address")
    end
  end

  describe "password_reset" do
    let(:user) { instance_double(User, email: "to@example.com") }
    let(:mail) { Emails::UserMailer.password_reset(user, "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq(["to@example.com"])
      expect(mail.from).to eq(["no-reply@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("reset your password")
    end
  end
end

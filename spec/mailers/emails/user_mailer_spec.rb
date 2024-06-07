require "rails_helper"

RSpec.describe Emails::UserMailer, type: :mailer do
  describe "confirmation" do
    let(:user) { instance_double(User, email: "to@example.com") }
    let(:mail) { Emails::UserMailer.confirmation(user, "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your email address")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["no-reply@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
  describe "confirmation" do
    let(:user) { instance_double(User, email: "from@example.com") }
    let(:mail) { Emails::UserMailer.password_reset(user, "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("Reset your password")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["no-replay@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end

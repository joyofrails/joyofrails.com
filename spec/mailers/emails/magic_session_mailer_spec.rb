require "rails_helper"

RSpec.describe Emails::MagicSessionMailer, type: :mailer do
  describe "sign_in_link" do
    let(:user) { instance_double(User, email: "to@example.com") }
    let(:mail) { Emails::MagicSessionMailer.sign_in_link(user, "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("Your sign-in link")
      expect(mail.to).to eq(["to@example.com"])
      expect(mail.from).to eq(["hello@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Click here to sign in")
    end
  end

  describe "no-account" do
    let(:email) { "to@example.com" }
    let(:mail) { Emails::MagicSessionMailer.no_account_found(email) }

    it "renders the headers" do
      expect(mail.subject).to eq("No account found")
      expect(mail.to).to eq(["to@example.com"])
      expect(mail.from).to eq(["hello@joyofrails.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Is this the right email?")
    end
  end
end

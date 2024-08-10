require "rails_helper"

RSpec.describe Emails::NewsletterMailer, type: :mailer do
  describe "#newsletter" do
    let(:newsletter) { instance_double(Newsletter, title: "A Newsletter", content: Faker::Markdown.sandwich(sentences: 3)) }
    let(:user) { instance_double(User, email: "to@example.com") }
    let(:mail) { Emails::NewsletterMailer.newsletter(newsletter:, user:, unsubscribe_token: "token") }

    it "renders the headers" do
      expect(mail.subject).to eq("A Newsletter")
      expect(mail.to).to eq(["to@example.com"])
      expect(mail.from).to eq(["hello@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(newsletter.content.split("\n").first)
    end
  end
end

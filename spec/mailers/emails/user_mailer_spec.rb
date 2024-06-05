require "rails_helper"

RSpec.describe Emails::UserMailer, type: :mailer do
  describe "confirmation" do
    let(:mail) { Emails::UserMailer.confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirmation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end

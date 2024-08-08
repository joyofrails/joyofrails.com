require "rails_helper"

RSpec.describe Emails::AdminUserMailer, type: :mailer do
  describe "new_user" do
    let(:admin_user) { instance_double(AdminUser, email: "admin@example.com") }
    let(:user) { instance_double(User, confirmable_email: "user@example.com") }
    let(:mail) { Emails::AdminUserMailer.new_user(admin_user:, user:) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Joy of Rails User")
      expect(mail.to).to eq(["admin@example.com"])
      expect(mail.from).to eq(["hello@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("user@example.com")
      expect(mail.body.encoded).to match("just registered for Joy of Rails!")
    end
  end
end

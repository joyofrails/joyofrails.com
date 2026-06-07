require "rails_helper"

RSpec.describe "blocked_email_domains", type: :task do
  describe ":add" do
    it "creates a blocked email domain from task args" do
      Rake::Task["blocked_email_domains:add"].reenable

      expect {
        Rake::Task["blocked_email_domains:add"].invoke("spamdomain.com")
      }.to change(BlockedEmailDomain, :count).by(1)

      expect(BlockedEmailDomain.last.domain).to eq("spamdomain.com")
    end

    it "creates a blocked email domain from DOMAIN environment variable" do
      Rake::Task["blocked_email_domains:add"].reenable
      ENV["DOMAIN"] = "example.com"

      expect {
        Rake::Task["blocked_email_domains:add"].invoke
      }.to change(BlockedEmailDomain, :count).by(1)

      expect(BlockedEmailDomain.last.domain).to eq("example.com")
    ensure
      ENV.delete("DOMAIN")
    end
  end
end

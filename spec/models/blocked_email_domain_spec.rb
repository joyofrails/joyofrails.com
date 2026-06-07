# == Schema Information
#
# Table name: blocked_email_domains
# Database name: primary
#
#  id         :integer          not null, primary key
#  domain     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_blocked_email_domains_on_domain  (domain) UNIQUE
#
require "rails_helper"

RSpec.describe BlockedEmailDomain, type: :model do
  describe ".blocked?" do
    it "returns true for a blocked domain string" do
      BlockedEmailDomain.create!(domain: "spamdomain.com")

      expect(BlockedEmailDomain.blocked?("spamdomain.com")).to be(true)
    end

    it "returns true for an email address with a blocked domain" do
      BlockedEmailDomain.create!(domain: "spamdomain.com")

      expect(BlockedEmailDomain.blocked?("joe@spamdomain.com")).to be(true)
    end

    it "returns false for an unblocked domain" do
      expect(BlockedEmailDomain.blocked?("goodexample.com")).to be(false)
    end
  end
end

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
class BlockedEmailDomain < ApplicationRecord
  normalizes :domain, with: ->(domain) { domain.to_s.downcase.strip.sub(/\A@/, "") }

  validates :domain, presence: true, uniqueness: true, format: {with: /\A[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)*\.[a-z]{2,}\z/i}

  def self.blocked?(email_or_domain)
    domain = email_or_domain.to_s
    domain = domain.split("@", 2).last if domain.include?("@")
    domain = domain.to_s.downcase.strip.sub(/\A@/, "")
    return false if domain.blank?

    exists?(domain: domain)
  end
end

require "rails_helper"

RSpec.describe "Custom configuration" do
  describe "#application_name" do
    it { expect(Rails.configuration.x.application_name).to eq("Joy of Rails") }
  end

  describe "#vapid" do
    it { expect(Rails.configuration.x.vapid.subject).to eq("mailto:hello@example.com") }
    it { expect(Rails.configuration.x.vapid.public_key.length).to eq(87) }
    it { expect(Rails.configuration.x.vapid.private_key.length).to eq(43) }
  end

  describe "#postmark" do
    it { expect(Rails.configuration.x.postmark.api_token).to eq("POSTMARK_API_TEST") }
  end
end

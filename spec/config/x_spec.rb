require "rails_helper"

RSpec.describe "Custom configuration" do
  describe "#application_name" do
    it { expect(Rails.configuration.x.application_name).to eq("Joy of Rails") }
  end

  describe "#vapid" do
    it { expect(Rails.configuration.x.vapid.subject).to eq("mailto:hello@example.com") }
    it { expect(Rails.configuration.x.vapid.public_key).to be_present }
    it { expect(Rails.configuration.x.vapid.private_key).to be_present }
  end

  describe "#postmark" do
    it { expect(Rails.configuration.x.postmark.api_token).to eq("POSTMARK_API_TEST") }
  end

  describe "#skip_http_cache" do
    it { expect(Rails.configuration.skip_http_cache).to eq(false) }
  end
end

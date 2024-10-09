require "rails_helper"

RSpec.describe "Custom configuration" do
  describe "#vapid" do
    it { expect(Rails.configuration.x.vapid.subject).to eq("mailto:hello@example.com") }
    it { expect(Rails.configuration.x.vapid.public_key.length).to eq(87) }
    it { expect(Rails.configuration.x.vapid.private_key.length).to eq(43) }
  end
end

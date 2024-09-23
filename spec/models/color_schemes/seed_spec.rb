require "rails_helper"

RSpec.describe ColorSchemes::Seed do
  describe "#seed_all" do
    it "creates color scheme data and is idempotent" do
      aggregate_failures do
        expect {
          described_class.new.seed_all
        }.to change(ColorScheme, :count).by_at_least 100

        expect {
          described_class.new.seed_all
        }.not_to change(ColorScheme, :count)
      end
    end
  end
end

require "rails_helper"

RSpec.describe Pwa::InstallationInstructions, type: :model do
  it { expect(described_class.new("").partial_name).to eq("unsupported") }

  describe "#partial_name" do
    common_user_agents = File.read("spec/fixtures/user_agents.txt").split("\n")
    valid_partial_names = Rails.root.join("app", "views", "pwa", "installation_instructions")
      .children
      .map { |path| path.basename.to_s.split(".").first }
      .filter_map { |partial_name| partial_name.sub(/^_/, "") if partial_name.starts_with?("_") }

    common_user_agents.each do |user_agent|
      it "should provide a valid partial name for #{user_agent}" do
        expect(described_class.new(user_agent).partial_name).to be_in(valid_partial_names)
      end
    end
  end
end

require "rails_helper"

RSpec.describe Pwa::UserAgentInstallationInstructions, type: :model do
  it { expect(described_class.new("").partial_name).to eq("unsupported") }

  describe "#partial_name" do
    common_user_agents = File.read("spec/fixtures/user_agents.txt").split("\n")
    valid_partial_names = Pwa::NamedInstallationInstructions.user_agent_nicknames.map do |nickname|
      "pwa/installation_instructions/user_agents/#{nickname}"
    end + ["desktop_firefox", "unsupported"]

    common_user_agents.each do |user_agent|
      it "should provide a valid partial name for #{user_agent}" do
        expect(described_class.new(user_agent).partial_name).to be_in(valid_partial_names)
      end
    end
  end
end

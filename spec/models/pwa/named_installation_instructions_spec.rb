require "rails_helper"

RSpec.describe Pwa::NamedInstallationInstructions, type: :model do
  describe "self.find" do
    it { expect { described_class.find(nil) }.to raise_error(ActiveRecord::RecordNotFound) }
    it { expect { described_class.find("sprinkes_and_rainbows") }.to raise_error(ActiveRecord::RecordNotFound) }
    it { expect(described_class.find("macos_safari")).to be_a(described_class) }
  end

  describe "#partial_name" do
    it { expect(described_class.new("macos_safari").partial_name).to eq("pwa/installation_instructions/user_agents/macos_safari") }
  end
end

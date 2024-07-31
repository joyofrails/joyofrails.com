require "rails_helper"

RSpec.describe Settings::SyntaxHighlight, type: :request do
  describe "#==" do
    it { expect(described_class.find("dracula")).to eq(described_class.find("dracula")) }
    it { expect(described_class.find("darcula")).not_to eq(described_class.find("dracula")) }
    it { expect(described_class.find("darcula")).not_to eq("darcula") }
  end

  describe ".curated" do
    it "represents the files in the curated directory" do
      assets = Dir.glob(Rails.root.join("app", "assets", "stylesheets", "pygments", "*.css"))

      expect(described_class.curated.map { |s| s.path.to_s }).to match_array(assets),
        "Expected the curated syntax highlights to match CSS files in pygments css directory. " \
        "You may need to run `rake syntax_highlights:seed` to update the curated syntax highlights."
    end
  end
end

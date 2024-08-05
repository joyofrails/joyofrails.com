require "rails_helper"

RSpec.describe ColorSchemes::Css do
  describe "#call" do
    it "renders valid css" do
      component = described_class.new(color_scheme: FactoryBot.build(:color_scheme))

      validator = W3CValidators::CSSValidator.new
      validator_results = validator.validate_text(component.call)

      expect(validator_results.is_valid?).to be(true), "Expected feed to be valid, but got: #{validator_results.errors.map(&:to_s).join(", ")}"
    end
  end
end

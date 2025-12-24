require "rails_helper"

RSpec.describe ColorSchemes::Css do
  describe "#call" do
    it "renders valid css" do
      validator = W3CValidators::CSSValidator.new

      render_component(color_scheme: FactoryBot.build(:color_scheme))

      validator_results = validator.validate_text(rendered)

      expect(validator_results.is_valid?).to be(true), "Expected feed to be valid, but got: #{validator_results.errors.map(&:to_s).join(", ")}"
    rescue W3CValidators::ValidatorUnavailable => e
      puts "Feed validation failed: #{e.message}"
    end
  end
end

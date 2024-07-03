require "rails_helper"

RSpec.describe ColorScheme, type: :model do
  describe "self.find_or_create_default" do
    it "should be idempotent" do
      expect {
        ColorScheme.find_or_create_default
      }.to change(ColorScheme, :count).by(1)

      expect {
        ColorScheme.find_or_create_default
      }.not_to change(ColorScheme, :count)
    end
  end

  describe "#weights" do
    it "should return a hash of all weights" do
      color_scheme = FactoryBot.build(:color_scheme)

      # ColorConversion::Color objects don’t implement #==, so we convert to hex
      expect(color_scheme.weights.transform_values { |color| color.hex }).to eq(
        "50" => color_scheme.weight_50,
        "100" => color_scheme.weight_100,
        "200" => color_scheme.weight_200,
        "300" => color_scheme.weight_300,
        "400" => color_scheme.weight_400,
        "500" => color_scheme.weight_500,
        "600" => color_scheme.weight_600,
        "700" => color_scheme.weight_700,
        "800" => color_scheme.weight_800,
        "900" => color_scheme.weight_900,
        "950" => color_scheme.weight_950
      )
    end
  end
end

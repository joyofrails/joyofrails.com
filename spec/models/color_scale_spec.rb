require "rails_helper"

RSpec.describe ColorScale, type: :model do
  describe "self.find_or_create_default" do
    it "should be idempotent" do
      expect {
        ColorScale.find_or_create_default
      }.to change(ColorScale, :count).by(1)

      expect {
        ColorScale.find_or_create_default
      }.not_to change(ColorScale, :count)
    end
  end

  describe "#weights" do
    it "should return a hash of all weights" do
      color_scale = FactoryBot.build(:color_scale)

      # ColorConversion::Color objects don’t implement #==, so we convert to hex
      expect(color_scale.weights.transform_values { |color| color.hex }).to eq(
        "50" => color_scale.weight_50,
        "100" => color_scale.weight_100,
        "200" => color_scale.weight_200,
        "300" => color_scale.weight_300,
        "400" => color_scale.weight_400,
        "500" => color_scale.weight_500,
        "600" => color_scale.weight_600,
        "700" => color_scale.weight_700,
        "800" => color_scale.weight_800,
        "900" => color_scale.weight_900,
        "950" => color_scale.weight_950
      )
    end
  end
end

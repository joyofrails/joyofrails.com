# == Schema Information
#
# Table name: color_schemes
#
#  id         :string           not null, primary key
#  name       :string           not null
#  weight_100 :string           not null
#  weight_200 :string           not null
#  weight_300 :string           not null
#  weight_400 :string           not null
#  weight_50  :string           not null
#  weight_500 :string           not null
#  weight_600 :string           not null
#  weight_700 :string           not null
#  weight_800 :string           not null
#  weight_900 :string           not null
#  weight_950 :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_color_schemes_on_name  (name) UNIQUE
#
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

  describe "self.bulk_load" do
    it "should create new color schemes from hash object" do
      data = {
        Heliotrope: {
          "50": "#fbf5ff",
          "100": "#f5e8ff",
          "200": "#edd6fe",
          "300": "#dfb5fd",
          "400": "#cf90fa",
          "500": "#b758f4",
          "600": "#a437e6",
          "700": "#8e25cb",
          "800": "#7724a5",
          "900": "#621e85",
          "950": "#430962"
        },

        Watercourse: {
          "50": "#ebfef6",
          "100": "#cffce7",
          "200": "#a3f7d4",
          "300": "#68edbf",
          "400": "#2ddaa4",
          "500": "#08c18e",
          "600": "#009d74",
          "700": "#007d60",
          "800": "#026b53",
          "900": "#035141",
          "950": "#002e25"
        }
      }

      expect {
        ColorScheme.bulk_load(data)
      }.to change(ColorScheme, :count).by(2)

      expect(ColorScheme.find_by(name: "Heliotrope")).to be_present
      expect(ColorScheme.find_by(name: "Watercourse")).to be_present
    end

    it "should allow customization of name" do
      data = {
        heliotrope: {
          "50": "#fbf5ff",
          "100": "#f5e8ff",
          "200": "#edd6fe",
          "300": "#dfb5fd",
          "400": "#cf90fa",
          "500": "#b758f4",
          "600": "#a437e6",
          "700": "#8e25cb",
          "800": "#7724a5",
          "900": "#621e85",
          "950": "#430962"
        }
      }

      ColorScheme.bulk_load(data) { |name| "Custom #{name.titleize}" }

      expect(ColorScheme.find_by(name: "Custom Heliotrope")).to be_present
    end

    it "should not duplicate" do
      FactoryBot.create(:color_scheme, name: "Custom Heliotrope")

      data = {
        heliotrope: {
          "50": "#fbf5ff",
          "100": "#f5e8ff",
          "200": "#edd6fe",
          "300": "#dfb5fd",
          "400": "#cf90fa",
          "500": "#b758f4",
          "600": "#a437e6",
          "700": "#8e25cb",
          "800": "#7724a5",
          "900": "#621e85",
          "950": "#430962"
        }
      }

      expect {
        ColorScheme.bulk_load(data) { |name| "Custom #{name.titleize}" }
      }.not_to change(ColorScheme, :count)
    end
  end

  describe "#weights" do
    it "should return a hash of all weights" do
      color_scheme = FactoryBot.build(:color_scheme)

      # ColorConversion::Color objects don’t implement #==, so we convert to hex
      expect(color_scheme.weights).to eq(
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

# frozen_string_literal: true

class ColorScale < ApplicationRecord
  APP_DEFAULT = {
    name: "Custom Cerulean Blue",
    weights: {
      "50": "#f1f5fd",
      "100": "#dfe8fa",
      "200": "#c7d7f6",
      "300": "#a1beef",
      "400": "#749be6",
      "500": "#537ade",
      "600": "#3e5dd2",
      "700": "#354bc0",
      "800": "#313f9c",
      "900": "#2c397c",
      "950": "#1f244c"
    }
  }.freeze

  VALID_WEIGHTS = %w[50 100 200 300 400 500 600 700 800 900 950].freeze

  def self.find_or_create_default
    find_or_create_by(name: APP_DEFAULT[:name]) do |cs|
      APP_DEFAULT[:weights].each do |weight, value|
        cs.set_weight(weight, value)
      end
    end
  end

  def set_weight(weight, value)
    raise ArgumentError, "Invalid weight: #{weight}" unless VALID_WEIGHTS.include?(weight.to_s)

    send(:"weight_#{weight}=", value)
  end

  def weights
    VALID_WEIGHTS.each_with_object({}) do |weight, hash|
      hash[weight] = send(:"weight_#{weight}")
    end
  end

  def to_css
    weights.map { |weight, value| "--color-#{name.dasherize}-#{weight}: #{value};" }.join("\n")
  end
end

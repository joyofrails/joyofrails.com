# frozen_string_literal: true

require "color_conversion"

class ColorScheme < ApplicationRecord
  APP_DEFAULT = {
    name: "Custom Cerulean Blue",
    weights: APP_DEFAULT_WEIGHTS = {
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
    }.freeze
  }.freeze

  VALID_WEIGHTS = APP_DEFAULT_WEIGHTS.keys.map(&:to_s).freeze

  VALID_WEIGHTS.each do |weight|
    # seralize :weight_50, coder: Color
    # seralize :weight_100, coder: Color
    # seralize :weight_200, coder: Color
    # etc
    serialize :"weight_#{weight}", coder: Color
  end

  def self.curated
    names = YAML.load_file(Rails.root.join("config", "curated_colors.yml"))
    where(name: names)
  end

  def self.cached_curated
    cache_key = "curated_color_scheme_ids"
    cached_ids = Rails.cache.read(cache_key)

    return where(id: cached_ids) if cached_ids

    curated.tap do |collection|
      Rails.cache.write(cache_key, collection.map(&:id))
    end
  end

  def self.find_or_create_default
    find_or_create_by(name: APP_DEFAULT[:name]) do |cs|
      APP_DEFAULT[:weights].each do |weight, value|
        cs.set_weight(weight, value)
      end
    end
  end

  def self.cached_default
    cache_key = "default_color_scheme_id"
    cached_id = Rails.cache.read(cache_key)

    return where(id: cached_id).first if cached_id

    find_or_create_default.tap do |cs|
      Rails.cache.write(cache_key, cs.id)
    end
  end

  def set_weight(weight, value)
    raise ArgumentError, "Invalid weight: #{weight}" unless VALID_WEIGHTS.include?(weight.to_s)

    send(:"weight_#{weight}=", value)
  end

  def weights
    VALID_WEIGHTS.map { |weight| [weight, send(:"weight_#{weight}")] }.to_h
  end

  def display_name
    name.gsub("Custom ", "")
  end
end

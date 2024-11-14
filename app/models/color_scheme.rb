# frozen_string_literal: true

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

  def self.cached_curated_color_scheme_options
    Rails.cache.fetch("curated_color_scheme_options", expires_in: 1.day) do
      ColorScheme.curated.sort_by { |cs| cs.name }.map { |cs| [cs.display_name, cs.id] }
    end
  end

  # @param [Hash] data in the format of { "name": { "50": "#000000", ..., "950": "#ffffff" }, ... }
  # @param [Block] block to transform the name
  def self.bulk_load(data, &block)
    data.each do |name, weights|
      name = name.to_s
      name = yield(name) if block
      ColorScheme.find_or_create_by!(name: name) do |cs|
        weights.each do |weight, css|
          cs.set_weight(weight, css)
        end
      end
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

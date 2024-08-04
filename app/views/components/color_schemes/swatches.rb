# frozen_string_literal: true

class ColorSchemes::Swatches < ApplicationComponent
  attr_reader :color_scheme

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def view_template
    div(class: "color-scheme color-scheme__#{color_scheme.name.parameterize} grid-cols-12") do
      color_scheme.weights.each do |weight, color|
        div(class: "color-swatch color-swatch__weight:#{weight}", style: "background-color: #{color.hex}") do
          div(class: "color-swatch__weight") { weight }
          div(class: "color-swatch__color") { color.hex.delete("#").upcase }
        end
      end
    end
  end
end

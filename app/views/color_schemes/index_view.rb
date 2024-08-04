# frozen_string_literal: true

class ColorSchemes::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo

  def initialize(color_schemes:)
    @color_schemes = color_schemes
  end

  def view_template
    render Pages::Header.new(title: "Color Scheme Index")

    section(class: "section-content container py-gap") do
      div(class: "grid grid-content") do
        @color_schemes.each do |color_scheme|
          style do
            render ColorSchemes::Css.new(color_scheme: color_scheme)
          end
          h2 do
            link_to color_scheme do
              span(style: inline_style_header_color(color_scheme)) { color_scheme.display_name }
            end
          end
          render ColorSchemes::Swatches.new(color_scheme: color_scheme)
        end
      end
    end
  end

  private

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end
end

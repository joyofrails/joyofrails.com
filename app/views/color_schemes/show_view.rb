# frozen_string_literal: true

class ColorSchemes::ShowView < ApplicationView
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::LinkTo

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def view_template
    render Pages::Header.new(title: "Color Scheme: #{@color_scheme.display_name}")

    section(class: "section-content container py-gap") do
      style do
        render(ColorSchemes::Css.new(color_scheme: @color_scheme, my_theme_enabled: true))
      end

      div(class: "grid grid-content") do
        markdown do
          <<~MARKDOWN
            You are viewing the **#{@color_scheme.display_name}** color scheme.
          MARKDOWN
        end

        h2 do
          span(style: inline_style_header_color(@color_scheme)) do
            @color_scheme.display_name
          end
        end

        render ColorSchemes::Swatches.new(color_scheme: @color_scheme)

        link_to "Back to index", color_schemes_path
      end
    end
  end

  private

  def inline_style_header_color(color_scheme)
    "color: var(--color-#{color_scheme.name.parameterize}-500)"
  end
end

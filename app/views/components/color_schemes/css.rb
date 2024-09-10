# frozen_string_literal: true

class ColorSchemes::Css < Phlex::HTML
  attr_reader :color_scheme

  def initialize(color_scheme:, my_theme_enabled: false)
    @color_scheme = color_scheme
    @my_theme = my_theme_enabled
  end

  def view_template
    raw safe(css_variables)
    if my_theme?
      raw safe(my_css_variables)
    end
  end

  def css_variables
    css = weights.map { |weight, color| "--color-#{color_name}-#{weight}: #{to_hsla(color)};" }.join("\n\s\s")
    <<~CSS
      :root {
        #{css}
      }
    CSS
  end

  def my_css_variables
    css = weights.map { |weight, color| "--my-color-#{weight}: var(--color-#{color_name}-#{weight});" }.join("\n\s\s")
    <<~CSS
      :root {
        #{css}
      }
    CSS
  end

  private

  delegate :weights, to: :color_scheme

  def color_name = color_scheme.name.parameterize

  def my_theme? = @my_theme

  def to_hsla(color)
    hsl = color.hsl
    "hsla(#{hsl[:h]}, #{hsl[:s]}%, #{hsl[:l]}%, 1)"
  end
end

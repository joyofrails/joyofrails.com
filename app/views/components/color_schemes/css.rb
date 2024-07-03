class ColorSchemes::Css < Phlex::HTML
  attr_reader :color_scheme

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def color_name
    color_scheme.name.parameterize
  end

  def to_hsla_css(color)
    hsl = color.hsl
    "hsla(#{hsl[:h]}, #{hsl[:s]}%, #{hsl[:l]}%, 1)"
  end

  def view_template
    color_scheme.weights.each do |weight, color|
      unsafe_raw "--color-#{color_name}-#{weight}: #{to_hsla_css(color)};\n"
    end
    color_scheme.weights.each do |weight, color|
      unsafe_raw "--my-color-#{weight}: var(--color-#{color_name}-#{weight});\n"
    end
  end
end

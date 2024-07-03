class ColorSchemes::Css < Phlex::HTML
  attr_reader :color_scheme

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def view_template
    unsafe_raw <<-CSS
      :root {
        #{color_scheme.weights.map { |weight, color| "--color-#{color_name}-#{weight}: #{to_hsla_css(color)};" }.join("\n\t\t")}
        #{color_scheme.weights.map { |weight, color| "--my-color-#{weight}: var(--color-#{color_name}-#{weight});" }.join("\n\t\t")}
      }
    CSS
  end

  private

  def color_name
    color_scheme.name.parameterize
  end

  def to_hsla_css(color)
    hsl = color.hsl
    "hsla(#{hsl[:h]}, #{hsl[:s]}%, #{hsl[:l]}%, 1)"
  end
end

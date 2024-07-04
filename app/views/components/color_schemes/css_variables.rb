class ColorSchemes::CssVariables < Phlex::HTML
  attr_reader :color_scheme

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def view_template
    unsafe_raw <<-CSS
      :root {
        #{css_variables}
      }
    CSS
  end

  def css_variables
    color_scheme.weights.map { |weight, color| "--color-#{color_name}-#{weight}: #{to_hsla(color)};" }.join("\n\t\t")
  end

  private

  def color_name = color_scheme.name.parameterize

  def to_hsla(color)
    hsl = color.hsl
    "hsla(#{hsl[:h]}, #{hsl[:s]}%, #{hsl[:l]}%, 1)"
  end
end

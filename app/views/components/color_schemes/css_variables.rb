class ColorSchemes::CssVariables < Phlex::HTML
  attr_reader :color_scheme

  def initialize(color_scheme:, my_color: false)
    @color_scheme = color_scheme
    @my_color = my_color
  end

  def view_template
    unsafe_raw <<~CSS
      :root {
        #{css_variables}
      }
    CSS
    if @my_color
      unsafe_raw <<~CSS
        :root {
          #{my_css_variables}
        }
      CSS
    end
  end

  def css_variables
    weights.map { |weight, color| "--color-#{color_name}-#{weight}: #{to_hsla(color)};" }.join("\n\s\s")
  end

  def my_css_variables
    weights.map { |weight, color| "--my-color-#{weight}: var(--color-#{color_name}-#{weight});" }.join("\n\s\s")
  end

  private

  delegate :weights, to: :color_scheme

  def color_name = color_scheme.name.parameterize

  def to_hsla(color)
    hsl = color.hsl
    "hsla(#{hsl[:h]}, #{hsl[:s]}%, #{hsl[:l]}%, 1)"
  end
end

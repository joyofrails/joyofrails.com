class ColorSchemes::Css < Phlex::HTML
  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def view_template
    render ColorSchemes::CssVariables.new(color_scheme: @color_scheme)
    render ColorSchemes::MyCssVariables.new(color_scheme: @color_scheme)
  end
end

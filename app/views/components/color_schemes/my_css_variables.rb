class ColorSchemes::MyCssVariables < ColorSchemes::CssVariables
  def css_variables
    color_scheme.weights.map { |weight, color| "--my-color-#{weight}: var(--color-#{color_name}-#{weight});" }.join("\n\t\t")
  end
end

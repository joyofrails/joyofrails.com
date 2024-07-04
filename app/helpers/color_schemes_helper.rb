module ColorSchemesHelper
  def render_color_scheme_form
    render ColorSchemes::Form.new(
      settings: Settings.new(color_scheme: find_color_scheme),
      curated_color_schemes: ColorScheme.cached_curated,
      preview_color_scheme: preview_color_scheme,
      session_color_scheme: session_color_scheme,
      default_color_scheme: default_color_scheme
    )
  end
end

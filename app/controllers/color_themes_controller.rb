class ColorThemesController < ApplicationController
  def show
    show_params = params[:color_theme] ? params.require(:color_theme).permit(:color_scale_id) : {}
    color_scale_id = show_params[:color_scale_id]
    @color_scale = color_scale_id ? ColorScale.find(color_scale_id) : ColorScale.find_or_create_default
    @color_theme = ColorTheme.new(color_scale: @color_scale)

    render ColorThemes::ShowView.new(
      color_theme: @color_theme,
      curated_color_scales: ColorScale.cached_curated,
      selected: color_scale_id.present?
    )
  end
end

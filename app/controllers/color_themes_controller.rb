class ColorThemesController < ApplicationController
  def show
    @color_scale = params[:id] ? ColorScale.find(params[:id]) : ColorScale.find_or_create_default
    curated_color_scales = ColorScale.cached_curated

    render ColorThemes::ShowView.new(
      color_scale: @color_scale,
      curated_color_scales: curated_color_scales
    )
  end
end

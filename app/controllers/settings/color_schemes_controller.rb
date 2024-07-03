class Settings::ColorSchemesController < ApplicationController
  def show
    @color_scale = selected_color_scale || session_color_scale || ColorScale.cached_default
    @settings = Settings.new(color_scale: @color_scale)

    render ColorSchemes::ShowView.new(
      settings: @settings,
      fallback_color_scale: session_color_scale || ColorScale.cached_default,
      curated_color_scales: ColorScale.cached_curated,
      selected: selected_color_scale_id.present?,
      saved: session[:color_scale_id].presence == @color_scale.id
    )
  end

  def update
    update_params = params[:settings] ? params.require(:settings).permit(:color_scale_id) : {}
    color_scale_id = update_params[:color_scale_id]
    @color_scale = ColorScale.find(color_scale_id)

    redirect_to settings_color_scheme_path unless @color_scale.present?

    if @color_scale == ColorScale.cached_default
      session.delete(:color_scale_id)
    else
      session[:color_scale_id] = @color_scale.id
    end

    redirect_to settings_color_scheme_path, status: :see_other
  end

  private

  def selected_color_scale_id = params.dig(:settings, :color_scale_id) || session[:color_scale_id]

  def session_color_scale = session[:color_scale_id] && ColorScale.find(session[:color_scale_id])

  def selected_color_scale = selected_color_scale_id && ColorScale.find(selected_color_scale_id)
end

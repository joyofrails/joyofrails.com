class Settings::ColorSchemesController < ApplicationController
  def show
    @color_scheme = selected_color_scheme || session_color_scheme || ColorScheme.cached_default
    @settings = Settings.new(color_scheme: @color_scheme)

    render ColorSchemes::ShowView.new(
      settings: @settings,
      fallback_color_scheme: session_color_scheme || ColorScheme.cached_default,
      curated_color_schemes: ColorScheme.cached_curated,
      selected: selected_color_scheme_id.present?,
      saved: session[:color_scheme_id].presence == @color_scheme.id
    )
  end

  def update
    update_params = params[:settings] ? params.require(:settings).permit(:color_scheme_id) : {}
    color_scheme_id = update_params[:color_scheme_id]
    @color_scheme = ColorScheme.find(color_scheme_id)

    redirect_to settings_color_scheme_path unless @color_scheme.present?

    if @color_scheme == ColorScheme.cached_default
      session.delete(:color_scheme_id)
    else
      session[:color_scheme_id] = @color_scheme.id
    end

    redirect_to settings_color_scheme_path, status: :see_other
  end

  private

  def selected_color_scheme_id = params.dig(:settings, :color_scheme_id) || session[:color_scheme_id]

  def session_color_scheme = session[:color_scheme_id] && ColorScheme.find(session[:color_scheme_id])

  def selected_color_scheme = selected_color_scheme_id && ColorScheme.find(selected_color_scheme_id)
end

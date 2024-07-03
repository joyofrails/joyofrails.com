class Settings::ColorSchemesController < ApplicationController
  def show
    @color_scheme = find_color_scheme

    respond_to do |format|
      format.html {
        render ColorSchemes::ShowView.new(
          settings: Settings.new(color_scheme: @color_scheme),
          curated_color_schemes: ColorScheme.cached_curated,
          preview_color_scheme: preview_color_scheme,
          session_color_scheme: session_color_scheme,
          default_color_scheme: default_color_scheme
        )
      }
      format.css {
        render ColorSchemes::Css.new(color_scheme: @color_scheme), layout: false
      }
    end
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
end

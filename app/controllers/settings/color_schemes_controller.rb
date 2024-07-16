class Settings::ColorSchemesController < ApplicationController
  after_action :send_plausible_event, only: :update

  def show
    @color_scheme = find_color_scheme

    respond_to do |format|
      format.html {
        render ColorSchemes::ShowView.new(
          settings: Settings.new(color_scheme: @color_scheme),
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

  private

  def send_plausible_event
    plausible_event "Color Scheme Update", props: {color_scheme: @color_scheme.name}
  end

  def plausible_event(name, props: {})
    Analytics::PlausibleEventJob.perform_later(
      name: name,
      url: request.original_url,
      props: props,
      referrer: request.referer,
      headers: {
        "User-Agent" => request.user_agent,
        "X-Forwarded-For" => request.remote_ip
      }
    )
  end
end

module ColorScheming
  extend ActiveSupport::Concern

  included do
    helper_method :custom_color_scheme_params
    helper_method :custom_color_scheme?
    helper_method :find_color_scheme
    helper_method :preview_color_scheme
    helper_method :session_color_scheme
    helper_method :default_color_scheme
  end

  protected

  def current_color_scheme
    Current.color_scheme ||= find_color_scheme
  end
  alias_method :ensure_current_color_scheme, :current_color_scheme

  def custom_color_scheme_params = preview_color_scheme_id ? {settings: {color_scheme_id: preview_color_scheme_id}} : {}

  def custom_color_scheme? = preview_color_scheme_id.present? || session_color_scheme_id.present?

  def find_color_scheme
    @color_scheme ||= preview_color_scheme || session_color_scheme || default_color_scheme
  end

  def preview_color_scheme_id = params.dig(:settings, :color_scheme_id)

  def session_color_scheme_id = session[:color_scheme_id]

  def preview_color_scheme = @preview_color_scheme ||= preview_color_scheme_id && ColorScheme.find(preview_color_scheme_id)

  def session_color_scheme = @session_color_scheme ||= session_color_scheme_id && ColorScheme.find(session_color_scheme_id)

  def default_color_scheme = @default_color_scheme ||= ColorScheme.cached_default
end

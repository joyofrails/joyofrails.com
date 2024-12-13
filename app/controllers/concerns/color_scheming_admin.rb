module ColorSchemingAdmin
  extend ActiveSupport::Concern

  included do
    before_action :use_admin_color_scheme
  end

  protected

  def use_admin_color_scheme
    Current.color_scheme = @color_scheme = @custom_color_scheme = default_admin_color_scheme || default_color_scheme
  end

  def default_admin_color_scheme = @default_admin_color_scheme ||= ColorScheme.cached_default_admin

  def default_color_scheme = @default_color_scheme ||= ColorScheme.cached_default
end

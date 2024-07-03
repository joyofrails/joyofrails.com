class ApplicationController < ActionController::Base
  include Erroring
  include Authentication

  before_action :set_color_theme

  def set_color_theme
    @color_scheme = find_color_theme
  end

  def find_color_theme
    if session[:color_scheme_id]
      begin
        return ColorScheme.find(session[:color_scheme_id])
      rescue ActiveRecord::RecordNotFound
      end
    end

    ColorScheme.cached_default
  end
end

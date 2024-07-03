class ApplicationController < ActionController::Base
  include Erroring
  include Authentication

  before_action :set_color_theme

  def set_color_theme
    @color_scale = find_color_theme
  end

  def find_color_theme
    if session[:color_scale_id]
      begin
        return ColorScale.find(session[:color_scale_id])
      rescue ActiveRecord::RecordNotFound
      end
    end

    ColorScale.cached_default
  end
end

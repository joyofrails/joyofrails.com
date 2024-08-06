class ColorSchemesController < ApplicationController
  def index
    @color_schemes = ColorScheme.curated

    render ColorSchemes::IndexView.new(color_schemes: @color_schemes)
  end

  def show
    @color_scheme = ColorScheme.find(params[:id])

    if stale?(@color_scheme, public: true)
      respond_to do |format|
        format.html { render ColorSchemes::ShowView.new(color_scheme: @color_scheme) }
        format.css { render ColorSchemes::Css.new(color_scheme: @color_scheme), layout: false }
      end
    end
  end
end

module Examples
  class RubyEnumerationsController < ApplicationController
    before_action :current_color_scheme

    layout false

    def show
      render Demo::RubyEnumeration.new(
        demo_type: params[:demo_type],
        is_dark_mode: requesting_dark_mode?,
        background: (@color_scheme.weight_50.hex unless requesting_dark_mode?)
      )
    end

    def requesting_dark_mode? = params[:is_dark_mode] == "true"
  end
end

module Examples
  class RubyEnumerationsController < ApplicationController
    before_action :current_color_scheme

    layout false

    def show
      render Demo::RubyEnumeration.new(demo_type: params[:demo_type])
    end
  end
end

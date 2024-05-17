module Redesign
  extend ActiveSupport::Concern

  included do
    layout proc { redesign_layout }

    helper_method :redesign?, :redesign_layout
  end

  def redesign_layout
    redesign? ? "redesign" : "application"
  end

  def redesign?
    params[:redesign] == "true" ||
      params[:redesign] == "1"
  end
end

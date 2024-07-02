class ColorTheme
  include ActiveModel::Model

  attr_accessor :color_scale

  def initialize(color_scale:)
    @color_scale = color_scale
  end
end

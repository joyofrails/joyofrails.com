require "color_conversion"

class Color
  def self.load(value)
    return nil if value.nil?
    new(value)
  end

  def self.dump(value)
    case value
    when Color
      value.hex
    else
      value
    end
  end

  def initialize(value)
    @_color = ColorConversion::Color.new(value)
  end

  def ==(other)
    return false unless other.is_a?(self.class)

    @_color == other.instance_variable_get(:@_color)
  end

  def hex
    @_color.hex
  end

  def rgb
    @_color.rgb
  end

  def hsl
    @_color.hsl
  end

  def rgba
    @_color.instance_variable_get(:@converter).rgba
  end

  def alpha
    @_color.alpha
  end

  def inspect
    "#<Color:#{object_id} rgb:#{rgb} alpha:#{alpha}>"
  end
end

class Settings
  include ActiveModel::Model

  attr_accessor :color_scheme

  def initialize(color_scheme:)
    @color_scheme = color_scheme
  end

  def color_scheme_id = color_scheme.id
end

class Settings
  include ActiveModel::Model

  attr_accessor :color_scheme, :syntax_highlight

  def initialize(color_scheme: nil, syntax_highlight: nil)
    @color_scheme = color_scheme
    @syntax_highlight = syntax_highlight
  end

  def color_scheme_id = color_scheme.id

  def syntax_highlight_name = syntax_highlight.name
end

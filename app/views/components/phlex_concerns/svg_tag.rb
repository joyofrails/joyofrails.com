module PhlexConcerns::SvgTag
  extend ActiveSupport::Concern

  included do
    include InlineSvg::ActionView::Helpers
  end

  def svg_tag(*, **)
    raw inline_svg_tag(*, **)
  end
end

class CodeBlock::Header < ApplicationComponent
  include InlineSvg::ActionView::Helpers

  def view_template(&)
    div(class: "code-header") do
      plain inline_svg_tag("app-dots.svg", class: "app-dots")
      span(class: "code-title", &)
    end
  end
end

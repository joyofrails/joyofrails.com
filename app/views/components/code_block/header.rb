class CodeBlock::Header < ApplicationComponent
  include PhlexConcerns::SvgTag

  def view_template(&)
    div(class: "code-header") do
      svg_tag("app-dots.svg", class: "app-dots")
      span(class: "code-title", &)
    end
  end
end

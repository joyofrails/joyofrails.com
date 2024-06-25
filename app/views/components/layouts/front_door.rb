class Layouts::FrontDoor < Phlex::HTML
  include InlineSvg::ActionView::Helpers

  def initialize(title:)
    @title = title
  end

  def view_template(&block)
    div(class: "flex min-h-full flex-col justify-center px-6 py-12 lg:px-8") do
      div(class: "") do
        plain inline_svg_tag "joy-logo.svg",
          class: "fill-current mx-auto",
          style: "max-width: 64px;",
          alt: "Joy of Rails"
        h2(
          class: "mt-4 text-center text-2xl font-bold leading-9 tracking-tight"
        ) { @title }
      end
      div(class: "", &block)
    end
  end
end

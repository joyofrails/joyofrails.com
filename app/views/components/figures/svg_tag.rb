class Figures::SvgTag < ApplicationComponent
  include PhlexConcerns::SvgTag

  def initialize(src, title: "", alt: nil, **options)
    @src = src
    @title = title
    @alt = alt
    @options = options
  end

  def view_template
    figure(**@options) do
      svg_tag(@src, title: @title, alt: @alt, **@options)
      figcaption { @title }
    end
  end
end

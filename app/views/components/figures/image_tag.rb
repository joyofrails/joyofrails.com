class Figures::ImageTag < ApplicationComponent
  include Phlex::Rails::Helpers::ImageTag

  def initialize(src, title: "", alt: nil, **options)
    @src = src
    @title = title
    @alt = alt
    @options = options
  end

  def view_template
    figure(**@options) do
      image_tag(@src, title: @title, alt: @alt)
      figcaption { @title }
    end
  end
end

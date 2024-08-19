class Markdown::Application < Markdown::Base
  include Phlex::Rails::Helpers::ImageTag
  include ActionView::Helpers::AssetUrlHelper
  include PhlexConcerns::Links

  # Options for CommonMarker
  def default_commonmarker_options
    {
      render: {
        unsafe: true
      }
    }
  end

  def code_block(source, language = "", **attributes)
    render CodeBlock::Code.new(source, language: language, **attributes)
  end

  def image(src, alt: "", title: "")
    figure do
      image_tag(src, alt: alt, title: title)
      figcaption { title }
    end
  end

  def html_block(html)
    unsafe_raw(html)
  end

  def html_inline(html)
    unsafe_raw(html)
  end
end

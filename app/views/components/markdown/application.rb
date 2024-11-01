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

  def code_block(source, metadata = "", **attributes)
    language, _ = metadata.split(":", 2)
    render CodeBlock::Code.new(source, language: language, **attributes)
  end

  def image(src, alt: "", title: "")
    title, _ = title.split("|", 2)
    figure do
      image_tag(src, alt: alt, title: title)
      figcaption { title }
    end
  end

  def html_block(html)
    raw safe(html)
  end

  def html_inline(html)
    raw safe(html)
  end
end

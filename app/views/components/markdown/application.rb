class Markdown::Application < Markdown::Base
  # Options for CommonMarker
  def default_commonmarker_options
    {
      render: {
        unsafe: true
      }
    }
  end

  def code_block(source, language = "", **attributes)
    render CodeBlock::Basic.new(source, language: language, **attributes)
  end

  def link(url, title, **attrs, &)
    attributes = attrs.dup
    unless url.blank? || url.start_with?("/", "#")
      attributes[:target] ||= "_blank"
      attributes[:rel] ||= "noopener noreferrer"
    end

    a(href: url, title: title, **attributes, &)
  end

  def html_block(html)
    unsafe_raw(html)
  end

  def html_inline(html)
    unsafe_raw(html)
  end

  private

  class Handler
    class << self
      def call(template, content)
        Markdown::Application.new(content).call
      end
    end
  end
end

class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet, :options

  def initialize(snippet, screenshot: false, **options)
    @snippet = snippet
    @screenshot = screenshot
    @options = options
  end

  def view_template
    div(class: "snippet-background", **options) do
      render CodeBlock::Container.new(language: language) do
        render CodeBlock::Header.new { title_content } if title_content.present?

        render CodeBlock::Body.new do
          render CodeBlock::Code.new(source, language: language)
          unless screenshot?
            whitespace
            render ClipboardCopy.new(text: source)
          end
        end
      end
    end
  end

  # Overwite the source code with a block
  def body(&)
    @source = capture(&)
  end

  def title_content
    filename.presence || language.presence || ""
  end

  def source
    snippet.source || ""
  end

  delegate :language, :filename, to: :snippet

  def screenshot? = @screenshot
end

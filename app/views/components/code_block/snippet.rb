class CodeBlock::Snippet < ApplicationComponent
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet, :options

  delegate :language, :filename, to: :snippet

  def initialize(snippet, screenshot: false, **options)
    @snippet = snippet
    @screenshot = screenshot
    @options = options
  end

  def view_template
    div(class: "snippet-background", **options) do
      render CodeBlock::Container.new(language: language, class: "snippet") do
        render CodeBlock::Header.new { header } if header.present?

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

  def header
    filename || language
  end

  def source
    snippet.source || ""
  end

  def screenshot? = @screenshot
end

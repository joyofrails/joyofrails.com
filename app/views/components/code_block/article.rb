class CodeBlock::Article < ApplicationComponent
  prepend CodeBlock::AtomAware

  attr_reader :source, :language, :filename, :options

  def initialize(source = "", language: nil, filename: nil, header: true, **options)
    @source = source
    @language = language
    @filename = filename
    @header = header
    @options = options
  end

  def view_template
    render CodeBlock::Container.new(language: language, **options) do
      render CodeBlock::Header.new { title } if show_header?

      render CodeBlock::Body.new do
        render CodeBlock::Code.new(source, language: language, **options)
        whitespace
        render ClipboardCopy.new(text: source)
      end
    end
  end

  def title
    @filename || @language
  end

  def show_header?
    @header
  end
end

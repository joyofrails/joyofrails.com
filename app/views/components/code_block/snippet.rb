class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  prepend CodeBlock::AtomAware

  attr_reader :snippet

  def initialize(snippet, **)
    @snippet = snippet
  end

  def view_template
    render CodeBlock::Container.new(language: language) do
      render CodeBlock::Header.new { title_content }

      render CodeBlock::Body.new do
        render CodeBlock::Code.new(source, language: language)
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
end

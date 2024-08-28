class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet, :data

  def initialize(snippet, editing: false, data: {}, **)
    @snippet = snippet
  end

  def view_template
    div(class: "snippet-background") do
      render CodeBlock::Container.new(language: language, class: "snippet") do
        render CodeBlock::Header.new do
          filename
        end

        render CodeBlock::Body.new do
          render CodeBlock::Code.new(source, language: language)
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
end

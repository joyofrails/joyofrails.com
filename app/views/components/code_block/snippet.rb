class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet

  def initialize(snippet, **)
    @snippet = snippet
  end

  def view_template
    render CodeBlock::Container.new(language: language, class: "snippet", id: dom_id(snippet, :code_block)) do
      render CodeBlock::Header.new { title_content }

      render CodeBlock::Body.new(data: {controller: "snippet-editor"}) do
        render CodeBlock::Code.new(source, language: language)
        div(class: "code-editor autogrow-wrapper") do
          textarea(
            name: "snippet[source]",
            data: {snippet_editor_target: "textarea", action: "input->snippet-editor#autogrow"}
          ) { source }
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

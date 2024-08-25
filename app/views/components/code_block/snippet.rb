class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet

  def initialize(snippet, **)
    @snippet = snippet
  end

  def view_template
    render CodeBlock::Container.new(language: language, class: "snippet") do
      render CodeBlock::Header.new do
        label(class: "sr-only", for: "snippet[filename]") { "Filename" }
        input(type: "text", name: "snippet[filename]", value: filename)
      end

      render CodeBlock::Body.new(data: {controller: "snippet-editor"}) do
        div(class: "grid-stack") do
          render CodeBlock::Code.new(source, language: language, data: {snippet_editor_target: "source"})
          label(class: "sr-only", for: "snippet[source]") { "Source" }
          div(class: "code-editor autogrow-wrapper") do
            textarea(
              name: "snippet[source]",
              data: {snippet_editor_target: "textarea"}
            ) { source }
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
end

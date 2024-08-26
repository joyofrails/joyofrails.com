class CodeBlock::Snippet < ApplicationComponent
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::DOMID
  prepend CodeBlock::AtomAware

  attr_reader :snippet

  def initialize(snippet, editing: false, **)
    @snippet = snippet
    @editing = editing
  end

  def view_template
    div(class: "snippet-background") do
      render CodeBlock::Container.new(language: language, class: "snippet") do
        render CodeBlock::Header.new do
          if editing?
            label(class: "sr-only", for: "snippet[filename]") { "Filename" }
            input(type: "text", name: "snippet[filename]", value: filename)
          else
            filename
          end
        end

        render CodeBlock::Body.new(data: controller_data) do
          div(class: "grid-stack") do
            render CodeBlock::Code.new(source, language: language, data: {snippet_editor_target: "source"})
            if editing?
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

  def editing? = !!@editing

  delegate :language, :filename, to: :snippet

  def controller_data
    editing? ? {controller: "snippet-editor"} : {}
  end
end

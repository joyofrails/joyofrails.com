class Share::Snippets::Form < ApplicationComponent
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::Pluralize

  attr_accessor :snippet

  def initialize(snippet:)
    @snippet = snippet
  end

  def view_template
    form_with(
      model: [:share, snippet],
      class: "grid-content",
      data: {
        controller: "snippet-preview snippet-screenshot",
        action: "snippet-editor:edit-finish->snippet-preview#preview"
      }
    ) do |form|
      errors

      language_select(form, data: {action: "change->snippet-preview#preview"})

      turbo_frame_tag dom_id(snippet, :code_block), class: "snippet-frame grid-cols-12" do
        div(class: "snippet-background", data: {snippet_screenshot_target: "snippet"}) do
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
      end

      fieldset do
        plain form.submit class: "button primary"
        whitespace
        plain form.button "Share",
          class: "button secondary",
          data: {
            action: "snippet-preview#share"
          }
        whitespace
        plain form.submit "Preview",
          class: "button secondary hidden",
          formaction: form_path,
          formmethod: "get",
          formnovalidate: true,
          data: {
            snippet_preview_target: "previewButton",
            turbo_frame: dom_id(snippet, :code_block)
          }
      end
    end
  end

  private

  def language = snippet.language

  def filename = snippet.filename

  def source = snippet.source || ""

  def errors
    if snippet.errors.any?
      div(style: "color:red") do
        h2 do
          pluralize(snippet.errors.count, "error")
          plain " prohibited this snippet from being saved:"
        end
        ul do
          snippet.errors.each do |error|
            li { error.full_message }
            whitespace
          end
        end
      end
    end
  end

  def language_select(form, data: {})
    div(class: "flex items-start flex-col space-col-4 md:items-center md:flex-row md:space-row-4") do
      fieldset do
        plain form.label :language, class: "sr-only"
        plain form.select :language,
          language_select_options,
          {},
          data:,
          class:
            "flex-1 rounded bg-white/5 focus-ring focus:ring-0 ring-1 ring-inset ring-white/10 w-full lg:min-w-[36ch]"
      end
    end
  end

  def language_select_options
    [%w[Auto auto]] +
      Rouge::Lexer.all.map { |lexer|
        [lexer.title, lexer.tag]
      }
  end

  def form_path
    if snippet.persisted?
      edit_share_snippet_path(snippet)
    else
      new_share_snippet_path
    end
  end
end

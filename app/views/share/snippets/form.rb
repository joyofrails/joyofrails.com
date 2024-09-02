class Share::Snippets::Form < ApplicationComponent
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::TurboStream
  include Phlex::Rails::Helpers::ButtonTo
  include PhlexConcerns::FlexBlock

  attr_accessor :snippet

  def initialize(snippet)
    @snippet = snippet
  end

  def view_template
    turbo_stream.update "flash", partial: "application/flash"
    div do
      form_with(
        model: [:share, snippet],
        class: "section-content",
        data: {
          controller: "snippet-preview",
          action: "snippet-editor:edit-finish->snippet-preview#preview"
        }
      ) do |form|
        errors

        div(class: "snippet-background") do
          render CodeBlock::Container.new(language: language, class: "snippet") do
            render CodeBlock::Header.new do
              label(class: "sr-only", for: "snippet[filename]") { "Filename" }
              input(type: "text", name: "snippet[filename]", value: filename)
            end

            turbo_frame_tag dom_id(snippet, :code_block) do
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
          flex_block do
            language_select(form, data: {action: "change->snippet-preview#preview"})

            plain form.submit "Share", class: "button primary"

            plain form.submit "Save", class: "button secondary"

            plain form.submit "Save & Close", class: "button secondary"

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

      if @snippet.persisted?
        br
        br
        div do
          flex_block do
            button_to "Destroy this snippet",
              share_snippet_path(@snippet), method: :delete,
              data: {confirm: "Are you sure?"},
              class: "button warn"
            # form: {style: "margin-left: auto"} # move to the right
          end
        end
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
      Rouge::Lexer.all
        .sort_by { |lexer| lexer.title }
        .map { |lexer|
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

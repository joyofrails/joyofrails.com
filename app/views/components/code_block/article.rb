class CodeBlock::Article < Phlex::HTML
  include InlineSvg::ActionView::Helpers
  include Phlex::DeferredRender

  def initialize(source = "", language: nil, filename: nil, run: false)
    @source = source
    @language = language
    @filename = filename
    @enable_run = run
  end

  def view_template(&block)
    # Capture the block content as the source if no source was provided
    # The capture call appears to add a leading space, so we strip it.
    @source ||= capture(&block)&.strip if block.present?

    div(
      class: "code-wrapper highlight language-#{language}",
      data: code_example_data.keep_if { enable_run }.merge(data)
    ) do
      div(class: "code-header") do
        plain inline_svg_tag("app-dots.svg", class: "app-dots")
        span(class: "code-title", &title_content)
      end

      div(class: "code-body") do
        render CodeBlock::Basic.new(source, language: language, data: {code_example_target: "source"})
        render ClipboardCopy.new(text: source)
      end

      if enable_run
        div(class: "code-footer") do
          div(class: "code-actions") do
            button(class: "button primary", data: {action: "click->code-example#run", code_example_target: "runButton"}) { "Run" }
            button(class: "button secondary hidden", data: {action: "click->code-example#clear", code_example_target: "clearButton"}) { "Clear" }
            span(class: "code-action-status", data: {code_example_target: "status"})
          end
          pre(class: "code-output hidden", data: {code_example_target: "output"}) do
            code
          end
          pre(class: "code-result hidden", data: {code_example_target: "result"}) do
            code
          end
        end
      end
    end
  end

  def title(&block)
    @title = block
  end

  # Overwite the source code with a block
  def source_code(&)
    @source = capture(&)
  end

  def title_content
    @title || -> { filename || language }
  end

  protected

  private

  attr_reader :source, :language, :filename, :enable_run

  def code_formatter
    self.class.code_formatter
  end

  def data = {language: language, lines:}

  def code_example_data = {
    controller: "code-example",
    code_example_vm_value: :rails
  }

  def lines = source.scan("\n").count + 1

  def lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText
end

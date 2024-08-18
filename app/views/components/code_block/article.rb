class CodeBlock::Article < Phlex::HTML
  include InlineSvg::ActionView::Helpers
  include Phlex::DeferredRender
  include Phlex::Rails::Helpers::ClassNames

  def initialize(
    source = "",
    language: nil,
    filename: nil,
    run: false,
    show_header: true,
    enable_copy: true,
    **options
  )
    @source = source || ""
    @language = language.presence
    @filename = filename.presence
    @enable_run = run
    @show_header = show_header
    @enable_copy = enable_copy
    @options = options
  end

  def view_template
    div(
      class: class_names("code-wrapper", "highlight", "language-#{language}", *options[:class]),
      data: code_example_data.keep_if { enable_run }.merge(data)
    ) do
      if @show_header
        div(class: "code-header") do
          plain inline_svg_tag("app-dots.svg", class: "app-dots mr-4")
          span(class: "code-title", &title_content)
        end
      end

      div(class: "code-body") do
        render CodeBlock::Basic.new(source, language: language, data: {code_example_target: "source"})
        render ClipboardCopy.new(text: source) if enable_copy
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
  def body(&)
    @source = capture(&)
  end

  def title_content
    @title || ->(*) { filename || language }
  end

  protected

  private

  attr_reader :source, :language, :filename, :enable_run, :enable_copy, :options

  def data = {language: language, lines:}

  def code_example_data = {
    controller: "code-example",
    code_example_vm_value: :rails
  }

  def lines = source.scan("\n").count + 1
end

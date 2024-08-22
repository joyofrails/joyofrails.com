class CodeBlock::AppFileRun < ApplicationComponent
  prepend CodeBlock::AtomAware

  attr_reader :app_file, :lines, :language

  # @param filename [String] the file path or an Examples::AppFile.
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, lines: nil, revision: "HEAD", language: nil, **attributes)
    @app_file = Examples::AppFile.from(filename, revision: revision)
    @lines = lines
    @attributes = attributes
    @language = language
  end

  def view_template
    render CodeBlock::Container.new(
      language: language,
      data: code_example_data
    ) do
      render CodeBlock::AppFileHeader.new(app_file)

      render CodeBlock::Body.new do
        render CodeBlock::Code.new(source, language: language)
        render ClipboardCopy.new(text: source)
      end

      render CodeBlock::Footer.new do
        actions
      end
    end
  end

  def actions
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

  def code_example_data
    {controller: "code-example", code_example_vm_value: :rails, language: language, lines:}
  end

  def source
    app_file.source(lines: lines)
  end
end

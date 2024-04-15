module CodeHelper
  def code_block_component(code, metadata, **options)
    enable_code_example = options[:enable_code_example].present?
    language, filename = metadata.split(":") if metadata

    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText

    data = {language: language}

    if enable_code_example
      data[:controller] = "code-example"
      data[:code_example_vm_value] = :rails
    end

    tag.div(
      class: "code-wrapper highlight language-#{language}",
      data: data
    ) do
      header = tag.div
      if filename
        header = tag.div(class: "code-header") do
          html = inline_svg("app-dots.svg", class: "app-dots")
          if filename
            html += tag.span(filename, class: "code-filename")
          end
          html
        end
      end

      body = tag.div(class: "code-body") do
        tag.pre do
          tag.code data: {code_example_target: "source"} do
            raw code_formatter.format(lexer.lex(code))
          end
        end + clipboard_copy(code)
      end

      footer = ""
      if enable_code_example
        footer = tag.div(class: "code-footer") do
          tag.div(class: "code-actions") do
            tag.button("Run", class: "button primary", data: {action: "click->code-example#run", code_example_target: "runButton"}) +
              tag.button("Clear", class: "button secondary hidden", data: {action: "click->code-example#clear", code_example_target: "clearButton"}) +
              tag.span(class: "code-action-status", data: {code_example_target: "status"})
          end +
            tag.pre(class: "code-output hidden", data: {code_example_target: "output"}) do
              tag.code
            end +
            tag.pre(class: "code-result hidden", data: {code_example_target: "result"}) do
              tag.code
            end
        end
      end

      header + body + footer
    end
  end

  def code_formatter
    @code_formatter ||= Rouge::Formatters::HTML.new
  end

  def clipboard_copy(text)
    ApplicationController.render partial: "components/clipboard_copy", locals: {text: text}
  end
end

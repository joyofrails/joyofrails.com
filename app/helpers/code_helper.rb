module CodeHelper
  def code_block_component(code, metadata, **options)
    language, filename = metadata.split(":") if metadata

    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText

    data = {language: language}

    if options[:runnable]
      data[:controller] = "code-example"
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
      if options[:runnable]
        footer = tag.div(class: "code-footer") do
          tag.div(class: "code-actions") do
            tag.button("Run", class: "button primary", data: {action: "click->code-example#run"}) +
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

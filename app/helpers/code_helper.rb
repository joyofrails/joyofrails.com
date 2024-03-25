module CodeHelper
  def code_block_component(code, metadata)
    language, filename = metadata.split(":") if metadata

    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText

    tag.div(class: "code-wrapper highlight language-#{language}") do
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
          tag.code do
            raw code_formatter.format(lexer.lex(code))
          end
        end + clipboard_copy(code)
      end

      header + body
    end
  end

  def code_formatter
    @code_formatter ||= Rouge::Formatters::HTML.new
  end

  def clipboard_copy(text)
    ApplicationController.render partial: "components/clipboard_copy", locals: {text: text}
  end
end

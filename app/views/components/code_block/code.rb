# frozen_string_literal: true

class CodeBlock::Code < ApplicationComponent
  class << self
    def code_formatter
      @code_formatter ||= LineHighlighter.new(Rouge::Formatters::HTML.new, highlight_lines: 1..4)
    end
  end

  attr_reader :source, :language, :data

  def initialize(source = "", language: nil, data: {})
    @source = source
    @language = language
    @data = data
  end

  def view_template(&block)
    pre data: data do
      code do
        unsafe_raw self.class.code_formatter.format(lexer.lex(source))
      end
    end
  end

  protected

  private

  def code_formatter
    self.class.code_formatter
  end

  def lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText

  class LineHighlighter < Rouge::Formatter
    def initialize(formatter, opts = {})
      @formatter = formatter
      @tag_name = opts.fetch(:tag_name, "div")
      @class_format = opts.fetch(:class, "line-%i")
      @highlight_line_class = opts.fetch(:highlight_line_class, "hll")
      @highlight_lines = opts[:highlight_lines] || []
    end

    def stream(tokens, &b)
      token_lines(tokens).with_index(1) do |line_tokens, lineno|
        classes = sprintf(@class_format, lineno)
        classes += " #{@highlight_line_class}" if @highlight_lines.include? lineno

        yield %(<#{@tag_name} class="#{classes}">)
        @formatter.stream(line_tokens) { |formatted| yield formatted }
        yield %(\n</#{@tag_name}>)
      end
    end
  end
end

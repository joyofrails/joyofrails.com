class CodeBlock::Basic < Phlex::HTML
  class << self
    def code_formatter
      @code_formatter ||= Rouge::Formatters::HTML.new
    end
  end

  def initialize(source = nil, language: nil, data: {})
    @source = source
    @language = language
    @data = data
  end

  def view_template(&block)
    pre do
      code data: data do
        unsafe_raw self.class.code_formatter.format(lexer.lex(source))
      end
    end
  end

  protected

  private

  attr_reader :source, :language, :data

  def code_formatter
    self.class.code_formatter
  end

  def lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText
end

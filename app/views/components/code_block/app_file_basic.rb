class CodeBlock::AppFileBasic < Phlex::HTML
  # @param filename [String] the file path or an Examples::AppFile.
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, language: nil, lines: nil, revision: nil, **attributes)
    @app_file = Examples::AppFile.from(filename, revision: revision)
    @language = language
    @lines = lines
    @attributes = attributes
  end

  def view_template
    div(class: "code-wrapper highlight language-#{language}") do
      render ::CodeBlock::Basic.new(source, language: language, **attributes)
    end
  end

  private

  attr_reader :app_file, :language, :lines, :attributes

  def source
    app_file.source(lines: lines)
  end
end

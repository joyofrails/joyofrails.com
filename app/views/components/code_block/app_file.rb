class CodeBlock::AppFile < ApplicationComponent
  prepend CodeBlock::AtomAware

  attr_reader :app_file, :lines, :attributes, :language

  # @param filename [String] the file path or an Examples::AppFile.
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, language: nil, lines: nil, revision: "HEAD", **attributes)
    @app_file = Examples::AppFile.from(filename, revision: revision)
    @lines = lines
    @language = language
    @attributes = attributes
  end

  def view_template
    render CodeBlock::Container.new(language: language) do
      render CodeBlock::AppFileHeader.new(app_file)

      render CodeBlock::Body.new do
        render CodeBlock::Code.new(source, language: language)
        whitespace
        render ClipboardCopy.new(text: source)
      end
    end
  end

  def source
    app_file.source(lines: lines)
  end
end

class CodeBlock::AppFile < CodeBlock
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, lines: nil, **attributes)
    @app_file = Examples::AppFile.from(filename)
    @lines = lines
    source = nil
    super(source, **attributes)
  end

  def view_template
    super { read_file }
  end

  def title_content
    a(href: app_file.repo_url, target: "_blank", class: "not-prose flex items-center gap-1") {
      plain title
      plain inline_svg_tag("external-link.svg", class: "icon icon-sm", height: 12, width: 12)
    }
  end

  private

  attr_reader :app_file

  def path = app_file.path

  def filename = app_file.filename

  def read_file
    file = Rails.root.join(*path)
    lines = Array(@lines)
    file.read unless lines.present?

    content = if lines.present?
      readlines = app_file.readlines
      lines = lines.map { |e| [*e] }.flatten

      readlines.values_at(*lines).join.strip
    else
      file.read
    end

    content.html_safe
  end
end

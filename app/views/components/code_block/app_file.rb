class CodeBlock::AppFile < Phlex::HTML
  include InlineSvg::ActionView::Helpers

  # @param filename [String] the file path or an Examples::AppFile.
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, lines: nil, revision: nil, **attributes)
    @app_file = Examples::AppFile.from(filename, revision: revision)
    @lines = lines
    @attributes = attributes
  end

  def view_template
    render ::CodeBlock::Article.new("", **attributes) do |code_block|
      code_block.title do
        a(href: app_file.repo_url, target: "_blank", class: "not-prose flex items-center gap-1") {
          plain app_file.filename
          plain inline_svg_tag("external-link.svg", class: "icon icon-sm", height: 12, width: 12)
        }
      end

      code_block.source_code do
        read_file
      end
    end
  end

  private

  attr_reader :app_file, :attributes

  def path = app_file.path

  def read_file
    file = Rails.root.join(*path)
    lines = Array(@lines)
    file.read unless lines.present?

    content = if lines.present?
      readlines = app_file.readlines
      lines = lines.map { |e| [*e] }.flatten.map(&:to_i).map { |e| e - 1 }

      readlines.values_at(*lines).join
    else
      file.read
    end

    content.strip.html_safe
  end
end

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
    render ::CodeBlock::Article.new(**attributes) do |code_block|
      code_block.title do
        a(href: app_file.repo_url, target: "_blank", class: "nc flex items-center gap-1") {
          plain app_file.app_path.to_s
          plain inline_svg_tag("external-link.svg", class: "icon icon-sm", height: 12, width: 12)
        }
      end

      code_block.body do
        source
      end
    end
  end

  private

  attr_reader :app_file, :lines, :attributes

  def source
    app_file.source(lines: lines)
  end
end

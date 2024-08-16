class CodeBlock::AppFile < ApplicationComponent
  include InlineSvg::ActionView::Helpers

  # @param filename [String] the file path or an Examples::AppFile.
  # @param file [String] the file path or an Examples::AppFile.
  def initialize(filename, lines: nil, revision: "HEAD", **attributes)
    @app_file = Examples::AppFile.from(filename, revision: revision)
    @lines = lines
    @attributes = attributes
  end

  def view_template
    # When an AppFile code block renders within an Atom feed, we want to render the basic code block
    if content_type?("application/atom+xml")
      return render ::CodeBlock::Basic.new(source, **attributes)
    end

    render ::CodeBlock::Article.new(**attributes) do |code_block|
      code_block.title do
        link(app_file.repo_url, "Source code on Github", class: "nc") {
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

  def content_type?(type)
    helpers.headers["Content-Type"].to_s =~ %r{#{Regexp.escape(type)}}
  end
end

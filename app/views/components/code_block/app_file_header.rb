class CodeBlock::AppFileHeader < ApplicationComponent
  include InlineSvg::ActionView::Helpers

  attr_reader :app_file

  def initialize(app_file)
    @app_file = app_file
  end

  def view_template
    render CodeBlock::Header.new do
      link(app_file.repo_url, "Source code on Github", class: "nc") do
        plain app_file.app_path.to_s
        plain inline_svg_tag("external-link.svg", class: "icon icon-sm", height: 12, width: 12)
      end
    end
  end
end

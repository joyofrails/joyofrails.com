# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.
require "inline_svg/action_view/helpers"

class ApplicationMarkdown < Phlex::Markdown
  include InlineSvg::ActionView::Helpers
  include Phlex::Rails::Helpers::LinkTo

  class Handler
    class << self
      def call(template, content)
        ApplicationMarkdown.new(content).call
      end
    end
  end

  def doc
    Markly.parse(@content, flags: Markly::UNSAFE)
  end

  def visit(node)
    return if node.nil?

    case node.type
    in :header
      header(node.header_level) do
        visit_children(node)
      end
    in :link
      link(node.url, node.title) { visit_children(node) }
    in :inline_html
      unsafe_raw(node.string_content)
    in :html
      unsafe_raw(node.string_content)
    else
      super
    end
  end

  # # Reformats your boring punctation like " and " into “ and ” so you can look
  # # and feel smarter. Read the docs at https://github.com/vmg/redcarpet#also-now-our-pants-are-much-smarter
  # include Redcarpet::Render::SmartyPants

  # # If you need access to ActionController::Base.helpers, you can delegate by uncommenting
  # # and adding to the list below. Several are already included for you in the `MarkdownRails::Renderer::Rails`,
  # # but you can add more here.
  # #
  # delegate \
  #   :link_to,
  #   :inline_svg,
  #   :code_block_component,
  #   :code_formatter,
  #   :clipboard_copy,
  #   to: :helpers

  # def extensions
  #   [
  #     :autolink,
  #     :disable_indented_code_blocks,
  #     :fenced_code_blocks,
  #     :no_intra_emphasis,
  #     :smartypants
  #   ].map { |feature| [feature, true] }.to_h
  # end

  # def options
  #   {
  #     with_toc_data: true
  #   }
  # end

  def header(header_level, &)
    content = capture(&)
    anchor = content.parameterize
    send(:"h#{header_level}", id: anchor, class: "anchor group flex items-center") do
      a(href: "##{anchor}", class: ["anchor-link not-prose"]) do
        anchor_svg
        span(class: "sr-only") { "Link to heading" }
      end
      plain content
    end
  end

  def code_block(source, metadata, **options)
    language, filename, opts_string = metadata.to_s.split(":")

    enable_code_example = if options[:run].present?
      options[:run]
    else
      opts_string.to_s.split(",").include?("run")
    end

    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText

    data = {language: language}

    if enable_code_example
      data[:controller] = "code-example"
      data[:code_example_vm_value] = :rails
    end

    div(
      class: "code-wrapper highlight language-#{language}",
      data: data
    ) do
      if filename
        div(class: "code-header") do
          unsafe_raw inline_svg("app-dots.svg", class: "app-dots")
          if filename
            span(class: "code-filename") { filename }
          end
        end
      end

      div(class: "code-body") do
        pre do
          code data: {code_example_target: "source"} do
            unsafe_raw code_formatter.format(lexer.lex(source))
          end
        end
        clipboard_copy(source)
      end

      if enable_code_example
        div(class: "code-footer") do
          div(class: "code-actions") do
            button(class: "button primary", data: {action: "click->code-example#run", code_example_target: "runButton"}) { "Run" }
            button(class: "button secondary hidden", data: {action: "click->code-example#clear", code_example_target: "clearButton"}) { "Clear" }
            span(class: "code-action-status", data: {code_example_target: "status"})
          end
          pre(class: "code-output hidden", data: {code_example_target: "output"}) do
            code
          end
          pre(class: "code-result hidden", data: {code_example_target: "result"}) do
            code
          end
        end
      end
    end
  end

  def clipboard_copy(text)
    ApplicationController.render partial: "components/clipboard_copy", locals: {text: text}
  end

  def code_formatter
    @code_formatter ||= Rouge::Formatters::HTML.new
  end

  def link(url, title, **attrs, &)
    attributes = attrs.dup
    unless url.blank? || url.start_with?("/", "#")
      attributes[:target] ||= "_blank"
      attributes[:rel] ||= "noopener noreferrer"
    end

    a(href: url, title: title, **attributes, &)
  end

  private

  def anchor_svg
    unsafe_raw(<<-SVG)
      <svg version="1.1" aria-hidden="true" stroke="currentColor" viewBox="0 0 16 16" width="28" height="28">
        <path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path>
      </svg>
    SVG
  end
end

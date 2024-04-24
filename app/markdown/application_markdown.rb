# You should read the docs at https://github.com/vmg/redcarpet and probably
# delete a bunch of stuff below if you don't need it.
require "inline_svg/action_view/helpers"

class ApplicationMarkdown < Phlex::Markdown
  include InlineSvg::ActionView::Helpers

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

  # def renderer
  #   ::Redcarpet::Markdown.new(self.class.new(options), **extensions)
  # end

  # def link(url, title, text)
  #   custom_link_to(url, text)
  # end

  # def autolink(url, link_type)
  #   custom_link_to(url, url)
  # end

  # def header(text, header_level)
  #   content_tag "h#{header_level}", id: text.parameterize, class: "anchor group flex items-center" do
  #     anchor_tag(text, class: ["anchor-link not-prose"]) + text
  #   end
  # end

  def code_block(code, metadata, **options)
    enable_code_example = options[:enable_code_example].present?
    language, filename = metadata.split(":") if metadata

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
            unsafe_raw code_formatter.format(lexer.lex(code))
          end
        end
        clipboard_copy(code)
      end

      if enable_code_example
        div(class: "code-footer") do
          div(class: "code-actions") do
            button("Run", class: "button primary", data: {action: "click->code-example#run", code_example_target: "runButton"}) +
              button("Clear", class: "button secondary hidden", data: {action: "click->code-example#clear", code_example_target: "clearButton"}) +
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

  # def image(link, title, alt_text)
  #   url = URI(link)
  #   case url.host
  #   when "www.youtube.com"
  #     youtube_tag url, alt_text
  #   else
  #     image_tag(link, title: title, alt: alt_text, loading: "lazy")
  #   end
  # end

  # private

  # # This is provided as an example; there's many more YouTube URLs that this wouldn't catch.
  # def youtube_tag(url, alt)
  #   embed_url = "https://www.youtube-nocookie.com/embed/#{CGI.parse(url.query).fetch("v").first}"
  #   content_tag :iframe,
  #     src: embed_url,
  #     width: 560,
  #     height: 325,
  #     allow: "encrypted-media; picture-in-picture",
  #     allowfullscreen: true \
  #   do
  #     alt
  #   end
  # end

  # def custom_link_to(url, text)
  #   attributes = {}

  #   unless url.blank? || url.start_with?("/", "#")
  #     attributes[:target] = "_blank"
  #     attributes[:rel] = "noopener noreferrer"
  #   end

  #   link_to(raw(text), url, attributes)
  # end

  # def anchor_tag(text, **)
  #   link_to("##{text.parameterize}", **) do
  #     raw(anchor_svg) + content_tag(:span, "Link to heading", class: "sr-only")
  #   end
  # end

  # def anchor_svg
  #   <<-SVG
  #     <svg version="1.1" aria-hidden="true" stroke="currentColor" viewBox="0 0 16 16" width="28" height="28">
  #       <path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path>
  #     </svg>
  #   SVG
  # end
end

class Markdown::Article < Markdown::Application
  prepend Markdown::AllowsErb

  def header(header_level, &)
    content = capture(&)
    anchor = content.parameterize
    send(:"h#{header_level}", id: anchor, class: "anchor group flex items-center") do
      a(href: "##{anchor}", class: ["anchor-link not-prose"]) do
        anchor_svg
        span(class: "sr-only") { "Link to heading" }
        whitespace
      end
      raw safe(content)
    end
  end

  def code_block(source, metadata = "", **attributes)
    language, json_attributes = parse_text_and_metadata(metadata)
    render ::CodeBlock::Article.new(source, language: language, **json_attributes, **attributes)
  end

  def image(src, alt: "", title: "")
    title, json_attributes = parse_text_and_metadata(title, separator: "|")
    figure(**json_attributes) do
      image_tag(src, alt: alt, title: title)
      figcaption { title }
    end
  end

  private

  # Parse the metadata string from a code block or title.
  #
  # @param metadata [String] the metadata string.
  # @return [Array<String, Hash>] the text and attributes.
  #
  # @example
  #   parse_text_and_metadata("ruby")
  #   => ["ruby", {}]
  # @example
  #   parse_text_and_metadata("ruby:{ \"filename\": \"main.rb\" }")
  #   => ["ruby", { filename: "main.rb" }]
  # @example
  #   parse_text_and_metadata("ruby:{ \"filename\": \"main.rb\", "run": true }")
  #   => ["ruby", { filename: "main.rb", run: true }]
  #
  def parse_text_and_metadata(metadata, separator: ":")
    text, json_string = metadata.split(separator, 2)

    json_attributes = begin
      JSON.parse(json_string.to_s, symbolize_names: true)
    rescue
      {}
    end

    [text, json_attributes]
  end

  def anchor_svg
    raw safe(<<-SVG)
      <svg version="1.1" aria-hidden="true" stroke="currentColor" viewBox="0 0 16 16" width="28" height="28">
        <path d="M4 9h1v1h-1c-1.5 0-3-1.69-3-3.5s1.55-3.5 3-3.5h4c1.45 0 3 1.69 3 3.5 0 1.41-0.91 2.72-2 3.25v-1.16c0.58-0.45 1-1.27 1-2.09 0-1.28-1.02-2.5-2-2.5H4c-0.98 0-2 1.22-2 2.5s1 2.5 2 2.5z m9-3h-1v1h1c1 0 2 1.22 2 2.5s-1.02 2.5-2 2.5H9c-0.98 0-2-1.22-2-2.5 0-0.83 0.42-1.64 1-2.09v-1.16c-1.09 0.53-2 1.84-2 3.25 0 1.81 1.55 3.5 3 3.5h4c1.45 0 3-1.69 3-3.5s-1.5-3.5-3-3.5z"></path>
      </svg>
    SVG
  end

  class Handler
    class << self
      def call(template, content)
        Markdown::Article.new(content).call
      end
    end
  end
end

class Atom::EntryContent
  # @param article [Sitepress::Model] the article to render for atom feed
  def initialize(article, request: nil)
    @article = article
    @request = request
  end

  def render
    html = render_template_html

    Nokogiri::HTML.fragment(html).tap do |fragment|
    end.to_html
  end

  private

  attr_reader :article, :request

  def base_url
    request&.base_url || ""
  end

  def render_template_html
    ApplicationController.render(
      inline: article.body,
      type: :"mdrb-atom",
      layout: false,
      content_type: article.mime_type.to_s,
      assigns: {
        format: :atom
      }
    )
  end
end

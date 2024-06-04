# Atom::EntryContent knows how to render a Sitepress::Model as an Atom feed entry.
# It uses a different Markdown component to avoid rendering "fancy" elements in the atom feed.
# It post-processes the rendered HTML to remove turbo-frames and replace them with a link.
class Atom::EntryContent
  include ActionView::Helpers::UrlHelper

  # @param article [Sitepress::Model] the article to render for atom feed
  def initialize(article, request: nil)
    @article = article
    @request = request
  end

  def render
    html = render_template_html

    doc = Nokogiri::HTML.fragment(html)

    doc.css("turbo-frame").each do |frame|
      frame.add_next_sibling(link_to("Click here to see content", article_url))
      frame.remove
    end

    doc.to_html
  end

  private

  attr_reader :article, :request

  def base_url
    request&.base_url || ""
  end

  def article_url
    base_url + article.request_path
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

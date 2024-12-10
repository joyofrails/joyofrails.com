# frozen_string_literal: true

# Atom::EntryContent knows how to render a Sitepress::Model as an Atom feed entry.
# It uses a different Markdown component to avoid rendering "fancy" elements in the atom feed.
# It post-processes the rendered HTML to
# - remove turbo-frames and replace them with a link
# - replace relative URLs with absolute URLs in images and links
class Atom::EntryContent
  include ActionView::Helpers::UrlHelper

  # @param page [Page] the Page instance to render for atom feed
  def initialize(page, request: nil)
    @page = page
    @request = request
  end

  def render
    html = page.body_html(format: :atom)

    doc = Nokogiri::HTML.fragment(html)

    doc.css("turbo-frame").each do |frame|
      frame_url = base_uri.merge(path: page.request_path, fragment: (frame["id"] if frame["id"])).to_s
      frame.add_next_sibling("(" + link_to("Go to the article to see dynamic content", frame_url) + ")")
      frame.remove
    end

    doc.css("img").each do |img|
      img["src"] = url(img["src"]) if img["src"].start_with?("/")
    end

    doc.css("a").each do |a|
      a["href"] = url(a["href"]) if a["href"].start_with?("/")
    end

    doc.to_html
  end

  private

  attr_reader :page, :request

  def base_uri
    @base_uri ||= Addressable::URI.parse(base_url)
  end

  def url(path)
    base_uri.join(path).to_s
  end

  def base_url
    request&.base_url || ""
  end

  def article_url
    url page.request_path
  end
end

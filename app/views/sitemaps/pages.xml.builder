xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
    xml.lastmod @last_modified_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  @pages.each do |page|
    xml.url do
      xml.loc Addressable::URI.join(root_url, page.request_path)
      xml.lastmod @last_modified_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end
  end

  @slash_pages.each do |path|
    xml.url do
      xml.loc Addressable::URI.join(root_url, path)
      xml.lastmod @last_modified_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end
  end
end

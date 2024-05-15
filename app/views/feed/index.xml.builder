xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Joy of Rails"
    xml.description "Tutorials and tips that capture the joy of building web applications with Ruby on Rails"
    xml.link root_url

    ArticlePage.published.take(10).each do |page|
      xml.item do
        xml.title page.data.title
        xml.description Markdown::Erb.new(page.body).call
        xml.pubDate page.published_on.to_formatted_s(:rfc822)
        xml.link request.base_url + page.request_path
        xml.guid request.base_url + page.request_path
      end
    end
  end
end

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Joy of Rails"
    xml.description "Tutorials and tips that capture the joy of building web applications with Ruby on Rails"
    xml.link root_url

    ArticlePage.published.take(10).each do |article|
      xml.item do
        xml.title article.data.title
        xml.description ::ApplicationController.render(
          inline: article.body,
          type: article.page.handler,
          layout: false,
          content_type: article.page.mime_type.to_s
        )
        xml.pubDate article.published_on.to_formatted_s(:rfc822)
        xml.link request.base_url + article.request_path
        xml.guid request.base_url + article.request_path
      end
    end
  end
end

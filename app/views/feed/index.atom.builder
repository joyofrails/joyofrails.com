atom_feed do |feed|
  feed.title("Joy of Rails")
  feed.updated(@articles.first.published_on) if @articles.length > 0

  @articles.take(50).each do |article|
    feed.entry(
      article,
      url: request.base_url + article.request_path
    ) do |entry|
      entry.title(article.title)
      entry.content(
        ::ApplicationController.render(
          inline: article.body,
          type: "mdrb-atom",
          layout: false,
          content_type: article.mime_type.to_s
        ),
        type: "html"
      )

      entry.author do |author|
        author.name(article.author)
      end
    end
  end
end

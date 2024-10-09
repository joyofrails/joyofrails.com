atom_feed do |feed|
  feed.title(Rails.configuration.x.application_name)
  feed.updated(@articles.first.published_on) if @articles.length > 0

  @articles.take(50).each do |article|
    feed.entry(
      article,
      id: "tag:#{request.host},2005:article/#{article.data.uuid!}",
      url: request.base_url + article.request_path
    ) do |entry|
      entry.title(article.title)
      entry.content(Atom::EntryContent.new(article, request: request).render, type: "html")

      entry.author do |author|
        author.name(article.author)
      end
    end
  end
end

module ArticlesHelper
  def articles_list
    articles = ArticlePage.all
    if Rails.env.production?
      articles = articles.select { |article| !article.data.draft? }
    end
    articles
  end
end

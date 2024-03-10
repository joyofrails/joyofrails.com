class ArticleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :title, type: :string

  def make_article
    template "article.html.md", "app/content/pages/articles/#{article_file_name}.html.md"
  end

  private

  def title
    options[:title] || name
  end

  def article_file_name
    file_name.parameterize
  end
end

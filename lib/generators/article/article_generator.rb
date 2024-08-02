require "rails/generators"

class ArticleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :title, type: :string

  def copy_placeholder_image
    copy_file "placeholder.jpg", "app/assets/images/articles/#{article_file_name}/placeholder.jpg"
  end

  def make_article
    template "article.html.mdrb", "app/content/pages/articles/#{article_file_name}.html.mdrb"
  end

  private

  def title
    options[:title] || name
  end

  def article_file_name
    file_name.parameterize
  end
end

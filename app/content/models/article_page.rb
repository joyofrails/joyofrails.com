class ArticlePage < Sitepress::Model
  collection glob: "articles/*.html*"
  data :title, :published, :summary, :description, :tags

  def self.published
    all.filter { |article| article.published.present? }.sort_by { |article| article.published_on }
  end

  def self.draft
    all.filter { |article| article.published.blank? }
  end

  def published_on
    published.to_date
  end
  alias_method :published_at, :published_on

  def gravatar_image_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end
end

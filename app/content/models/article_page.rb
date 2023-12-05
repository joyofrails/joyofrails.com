class ArticlePage < Sitepress::Model
  collection glob: "articles/*.html*"
  data :title, :published_on, :summary, :description, :tags

  def gravatar_image_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end
end

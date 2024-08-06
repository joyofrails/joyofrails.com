class ArticlePage < Sitepress::Model
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  collection glob: "articles/*.html*"
  data :title, :published, :updated, :summary, :description, :tags, :image

  delegate :mime_type, :handler, to: :page

  def self.published
    all.filter(&:published?)
      .sort { |a, b| b.published_on <=> a.published_on } # DESC order
  end

  def self.draft
    all.filter(&:draft?)
  end

  def published?
    published_on.presence && published_on <= Date.today
  end

  def draft? = !published?

  def persisted?
    false
  end

  def published_on
    published&.to_date
  end
  alias_method :published_at, :published_on
  alias_method :created_at, :published_on

  def updated_on
    updated&.to_date || published_on
  end
  alias_method :updated_at, :updated_on

  def gravatar_image_url
    "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end

  def author
    data.author || "Ross Kaffenberger"
  end
end

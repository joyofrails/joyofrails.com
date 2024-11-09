# frozen_string_literal: true

# ActiveRecord model to represent a static page in the database.
# == Schema Information
#
# Table name: pages
#
#  id           :string           not null, primary key
#  indexed_at   :datetime
#  published_at :datetime
#  request_path :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_indexed_at    (indexed_at)
#  index_pages_on_published_at  (published_at)
#  index_pages_on_request_path  (request_path) UNIQUE
#
class Page < ApplicationRecord
  include Page::Searchable

  NullResource = Data.define(:request_path) do
    def data = NullData.new(title: nil, description: nil)
  end

  NullData = Data.define(:title, :description)

  has_many :page_topics, dependent: :destroy
  has_many :topics, through: :page_topics
  has_many :approved_topics, -> { approved }, through: :page_topics, source: :topic, inverse_of: :pages

  scope :published, -> { where(["published_at < ?", Time.zone.now]) }
  scope :indexed, -> { where(["indexed_at < ?", Time.zone.now]) }

  has_one :page_embedding, inverse_of: :page, foreign_key: :id, primary_key: :id

  scope :similar_to, ->(page) do
    select("pages.*")
      .select("similar_pages.distance")
      .from("(#{PageEmbedding.similar_to(page.page_embedding).to_sql}) similar_pages")
      .joins("LEFT JOIN pages ON similar_pages.id = pages.id")
      .where("similar_pages.id != ?", page.id)
      .order("similar_pages.distance ASC")
  end

  # def resource_data
  delegate :data, to: :resource, allow_nil: true, prefix: true

  # We currently have a dual system of content management between Sitepress and
  # Page models for handling static pages While not ideal, it currently allows
  # us to live in both worlds depending on the context.  Ultimately, migrating
  # away from Sitepress for indexed content may be what‘s needed, but keeping
  # the split personality for now.
  #
  def self.upsert_collection_from_sitepress!(limit: nil)
    enum = SitepressPage.all.resources.lazy

    if limit
      enum = enum.filter do |sitepress_resource|
        Page.find_by(request_path: sitepress_resource.request_path).nil?
      end
    end

    enum = enum.map do |sitepress_resource|
      upsert_page_from_sitepress!(sitepress_resource)
    end

    if limit
      enum = enum.take(limit)
    end

    enum.to_a
  end

  def self.upsert_page_from_sitepress!(sitepress_resource)
    page = Page.find_or_initialize_by(request_path: sitepress_resource.request_path)
    page.published_at = sitepress_resource.data.published.to_time.middle_of_day if sitepress_resource.data.published
    page.updated_at = sitepress_resource.data.updated.to_time.middle_of_day if sitepress_resource.data.updated
    page.save!
    page
  end

  def published? = !!published_at

  def published_on = published_at&.to_date

  def updated_on = updated_at&.to_date

  def indexed? = !!indexed_at

  def sitepress_article = SitepressArticle.new(resource)

  def resource = Sitepress.site.get(request_path) ||
    NullResource.new(request_path: request_path)

  def body_text = Nokogiri::HTML(SitepressPage.render_html(resource)).text.squish

  def title = resource.data.title

  def body = resource.body

  def description = resource.data.description

  def image = resource.data.image

  def meta_image = resource.data.meta_image

  def toc = resource.data.toc

  def enable_twitter_widgets = resource.data.toc

  def upsert_page_from_sitepress!
    self.class.upsert_page_from_sitepress!(resource)
  end
end

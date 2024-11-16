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
  include Page::Similarity
  include Page::Sitepressed

  has_many :page_topics, dependent: :destroy
  has_many :topics, through: :page_topics
  has_many :approved_topics, -> { approved }, through: :page_topics, source: :topic, inverse_of: :pages

  scope :published, -> { where(["published_at < ?", Time.zone.now]) }
  scope :indexed, -> { where(["indexed_at < ?", Time.zone.now]) }

  # def resource_data
  delegate :data, to: :resource, allow_nil: true, prefix: true

  def published? = !!published_at

  def published_on = published_at&.to_date

  def updated_on = updated_at&.to_date

  def indexed? = !!indexed_at

  # alias
  def resource = sitepress_resource

  def title = resource.data.title

  def body = resource.body

  def body_text = Nokogiri::HTML(SitepressPage.render_html(resource)).text.squish

  def description = resource.data.description

  def image = resource.data.image

  def meta_image = resource.data.meta_image

  def toc = resource.data.toc

  def enable_twitter_widgets = resource.data.toc
end

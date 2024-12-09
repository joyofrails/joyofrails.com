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

  has_many :page_polls, dependent: :destroy
  has_many :polls, through: :page_polls

  scope :published, -> { where(["published_at < ?", Time.zone.now]) }
  scope :draft, -> { where(["published_at > ?", Time.zone.now]) }
  scope :indexed, -> { where(["indexed_at < ?", Time.zone.now]) }

  def self.primary_author = User.find_by(email: Rails.configuration.x.emails.primary_author)

  def self.primary_author! = User.find_by!(email: Rails.configuration.x.emails.primary_author)

  def published? = !!published_at

  def published_on = published_at&.to_date

  def indexed? = !!indexed_at

  def body_text = Nokogiri::HTML(body_html(format: :atom)).text.squish

  def body_html(format: :html, **) = self.class.render_html(self, format:, **)

  # alias

  def revised_on = resource.updated_on

  def title = resource.title

  def body = resource.body

  def description = resource.description

  def image = resource.image

  def meta_image = resource.meta_image

  def toc = resource.toc

  def enable_twitter_widgets = resource.enable_twitter_widgets

  def atom_feed_id = resource.uuid.presence || id

  def author = resource.author
end

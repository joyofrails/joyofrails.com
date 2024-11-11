# frozen_string_literal: true

# ActiveRecord model to represent a static page in the database.
# == Schema Information
#
# Table name: pages
#
#  id           :string           not null, primary key
#  request_path :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_request_path  (request_path) UNIQUE
#
class Page < ApplicationRecord
  include Page::Searchable

  has_many :page_topics, dependent: :destroy
  has_many :topics, through: :page_topics
  has_many :approved_topics, -> { approved }, through: :page_topics, source: :topic, inverse_of: :pages

  def self.as_published_articles
    SitepressArticle.take_published(all.map { |page| SitepressArticle.new(page.resource) })
  end

  def sitepress_article
    SitepressArticle.new(resource)
  end

  def resource = Sitepress.site.get(request_path)

  def body_text = Nokogiri::HTML(SitepressPage.render_html(resource)).text.squish

  def url = request_path

  def title = resource.data.title

  def body = resource.body

  def description = resource.data.description

  def analyze_topics!
    Pages::AnalyzeTopicsJob.perform_later(self)
  end
end

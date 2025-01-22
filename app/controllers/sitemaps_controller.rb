class SitemapsController < ApplicationController
  def index
    respond_to do |format|
      format.xml
    end
  end

  def pages
    @last_modified_at = Time.now.middle_of_day.utc
    @pages = Page.all.published.order(published_at: :desc)

    @slash_pages = %w[
      about
      articles
      contact
      meta
      settings
    ]

    respond_to do |format|
      format.xml
    end
  end
end

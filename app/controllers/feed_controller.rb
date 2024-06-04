class FeedController < ApplicationController
  def index
    @articles = ArticlePage.published
    respond_to do |format|
      format.html { redirect_to feed_path(format: :atom), status: :moved_permanently }
      # format.xml { headers["Content-Type"] = 'application/rss+xml; charset=utf-8'}
      format.atom { headers["Content-Type"] = "application/atom+xml; charset=utf-8" }
    end
  end
end

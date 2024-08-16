class FeedController < ApplicationController
  def index
    @articles = ArticlePage.published
    respond_to do |format|
      format.html { redirect_to feed_path(format: :atom), status: :moved_permanently }
      format.atom
    end
  end
end

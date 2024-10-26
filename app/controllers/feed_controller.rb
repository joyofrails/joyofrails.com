class FeedController < ApplicationController
  def index
    @articles = SitepressArticle.published

    if Rails.configuration.skip_http_cache || stale?(@articles, public: true)
      respond_to do |format|
        format.html { redirect_to feed_path(format: :atom), status: :moved_permanently }
        format.atom
      end
    end
  end
end

class FeedController < ApplicationController
  def index
    @articles = Page.published.order(published_at: :desc).limit(50)

    if Rails.configuration.skip_http_cache || stale?(@articles, public: true)
      respond_to do |format|
        format.html { redirect_to feed_path(format: :atom), status: :moved_permanently }
        format.atom
      end
    end
  end
end

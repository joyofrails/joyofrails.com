class Share::SnippetsController < ApplicationController
  def index
    @snippets = Snippet.all.with_attached_screenshot.includes(:author).order(created_at: :desc)
  end

  def show
    @snippet = Snippet.find(params[:id])

    fresh_when(@snippet, public: true) unless user_signed_in?
  end
end

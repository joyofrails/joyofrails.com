class Share::SnippetScreenshotsController < ApplicationController
  using Refinements::Emojoy

  def show
    @snippet = Snippet.find(params[:snippet_id])

    render layout: false
  end

  def new
    @snippet = Snippet.find(params[:snippet_id])
  end

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @snippet.attach_screenshot_from_base64(params[:screenshot])
    redirect_to new_share_snippet_tweet_path(@snippet, auto: true), notice: "Screenshot attached".emojoy
  end
end

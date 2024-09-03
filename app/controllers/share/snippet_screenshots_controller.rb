class Share::SnippetScreenshotsController < ApplicationController
  using Refinements::Emojoy

  def show
    @snippet = Snippet.find(params[:snippet_id])

    render layout: false
  end

  def new
    @snippet = Snippet.find(params[:snippet_id])
    @auto = params[:auto] == "true"
  end

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @snippet.attach_screenshot_from_base64(params[:screenshot])
    redirect_to intent_url, notice: "Screenshot successful".emojoy
  end

  def intent_url
    case params[:intent]
    when "share"
      new_share_snippet_tweet_url(@snippet, auto: true)
    else
      share_snippet_url(@snippet)
    end
  end
end

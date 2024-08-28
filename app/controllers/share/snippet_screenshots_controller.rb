class Share::SnippetScreenshotsController < ApplicationController
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
    redirect_to share_snippet_url(@snippet), notice: "Screenshot attached."
  end
end

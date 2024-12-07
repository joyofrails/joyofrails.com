class Share::SnippetTweetsController < ApplicationController
  def new
    @snippet = Snippet.find(params[:snippet_id])
    @auto = params[:auto] == "true"
  end
end

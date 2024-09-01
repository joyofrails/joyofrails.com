class Share::SnippetTweetsController < ApplicationController
  using Refinements::Emojoy

  def new
    @snippet = Snippet.find(params[:snippet_id])
  end
end

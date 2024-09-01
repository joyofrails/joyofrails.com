class Share::SnippetTweets::Tweet < ApplicationComponent
  def initialize(snippet)
    @snippet = snippet
  end

  def view_template
    render CodeBlock::Snippet.new(
      @snippet,
      screenshot: true,
      data: {
        controller: "snippet-tweet",
        snippet_tweet_url_value: tweet_url
      }
    )
  end

  def tweet_url
    @snippet.screenshot.attached? ? rails_storage_proxy_url(@snippet.screenshot) : share_snippet_url(@snippet)
  end
end

class Share::SnippetTweets::TweetButton < ApplicationComponent
  def initialize(snippet, auto: false)
    @snippet = snippet
    @auto = auto
  end

  def view_template
    a(
      href: tweet_url,
      class: "button primary",
      data: {
        controller: "snippet-tweet",
        action: "click->snippet-tweet#tweet",
        snippet_tweet_auto_value: auto?.to_s,
        snippet_tweet_url_value: share_url
      }
    ) do
      "Share"
    end
  end

  def tweet_url
    "https://x.com/intent/post?text=#{encode(tweet_text)}"
  end

  def share_url
    share_snippet_url(@snippet)
  end

  def tweet_text
    "Created with @joyofrails #{share_url}"
  end

  def encode(text)
    URI.encode_www_form_component(text)
  end

  def auto? = !!@auto
end

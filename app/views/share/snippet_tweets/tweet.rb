class Share::SnippetTweets::Tweet < ApplicationComponent
  include Phlex::Rails::Helpers::ButtonTag
  include Phlex::Rails::Helpers::ClassNames
  include PhlexConcerns::FlexBlock

  def initialize(snippet, auto: false)
    @snippet = snippet
    @auto = auto
  end

  def view_template
    div(
      class: "snippet-tweet grid-content",
      data: {
        controller: "snippet-tweet",
        snippet_tweet_url_value: tweet_url,
        snippet_tweet_auto_value: auto?.to_s
      }
    ) do
      render CodeBlock::Snippet.new(
        @snippet,
        screenshot: true
      )

      flex_block do
        button_tag "Tweet",
          class: class_names("button", "primary", hidden: auto?),
          data: {action: "click->snippet-tweet#tweet"}
      end
    end
  end

  def tweet_url
    @snippet.screenshot.attached? ? rails_storage_proxy_url(@snippet.screenshot) : share_snippet_url(@snippet)
  end

  def auto? = !!@auto
end

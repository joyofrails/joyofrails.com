class Share::SnippetTweets::Tweet < ApplicationComponent
  include PhlexConcerns::FlexBlock

  def initialize(snippet, auto: false)
    @snippet = snippet
    @auto = auto
  end

  def view_template
    div(class: "snippet-tweet grid-content") do
      render CodeBlock::Snippet.new(
        @snippet,
        screenshot: true
      )

      flex_block do
        render Share::SnippetTweets::TweetButton.new(@snippet, auto: auto?)
      end
    end
  end

  def auto? = !!@auto
end

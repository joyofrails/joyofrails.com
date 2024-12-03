class Share::Snippets::Toolbar < ApplicationComponent
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::LinkTo
  include PhlexConcerns::FlexBlock

  attr_reader :snippet, :current_user

  def initialize(snippet, current_user: nil)
    @snippet = snippet
    @current_user = current_user
  end

  def view_template
    flex_block do
      render Share::SnippetTweets::TweetButton.new(snippet)

      a(href: share_snippet_path(snippet)) { "Link" }

      a(href: download_url) { "Download" }

      if current_user.can_edit?(snippet)
        a(
          href: edit_author_snippet_path(snippet),
          data: {turbo_frame: "snippet_form"}
        ) do
          "Edit this snippet"
        end
      end
    end
  end

  def share_url
    if snippet.screenshot.attached?
      new_share_snippet_tweet_path(@snippet, auto: "true")
    else
      new_share_snippet_screenshot_path(@snippet, auto: "true", intent: "share")
    end
  end

  def download_url
    if snippet.screenshot.attached?
      rails_blob_url(snippet.screenshot, disposition: "attachment")
    else
      new_share_snippet_screenshot_path(snippet, auto: "true", intent: "download")
    end
  end
end

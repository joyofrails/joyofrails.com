class Share::Snippets::Toolbar < ApplicationComponent
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::LinkTo
  include PhlexConcerns::FlexBlock

  def initialize(snippet, current_user: nil)
    @snippet = snippet
    @current_user = current_user
  end

  def view_template
    flex_block do
      link_to "Share", share_url, class: "button primary"
      if @current_user&.can_edit?(@snippet)
        link_to "Edit this snippet", edit_share_snippet_path(@snippet),
          class: "button secondary",
          data: {turbo_frame: "snippet_form"}
      end
    end
  end

  def share_url
    if @snippet.screenshot.attached?
      new_share_snippet_tweet_path(@snippet, auto: "true")
    else
      new_share_snippet_screenshot_path(@snippet, auto: "true")
    end
  end
end

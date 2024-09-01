class Share::Snippets::Toolbar < ApplicationComponent
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::LinkTo
  include PhlexConcerns::FlexBlock

  def initialize(snippet)
    @snippet = snippet
  end

  def view_template
    div do
      flex_block do
        link_to "Share", new_share_snippet_tweet_path(@snippet), class: "button primary"
        link_to "Edit this snippet", edit_share_snippet_path(@snippet), class: "button secondary"
      end
    end
  end
end

class Author::Snippets::Toolbar < ApplicationComponent
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
      a(href: author_snippet_path(snippet), class: "button secondary") do
        "Author view"
      end

      if current_user.can_edit?(snippet)
        a(
          href: edit_author_snippet_path(snippet),
          class: "button secondary",
          data: {turbo_frame: "snippet_form"}
        ) do
          "Edit this snippet"
        end
      end
    end
  end
end

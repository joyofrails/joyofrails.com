class Share::SnippetScreenshots::Form < ApplicationComponent
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::Pluralize

  attr_accessor :snippet

  def initialize(snippet)
    @snippet = snippet
  end

  def view_template
    form_with(
      model: snippet,
      url: share_snippet_screenshot_path(snippet),
      method: :post,
      class: "grid-content",
      data: {
        controller: "snippet-screenshot"
      }
    ) do |form|
      errors

      render CodeBlock::Snippet.new(snippet, screenshot: true, data: {snippet_screenshot_target: "snippet"})

      fieldset do
        plain form.button "Share", class: "button primary"
      end
    end
  end

  private

  def errors
    if snippet.errors.any?
      div(style: "color:red") do
        h2 do
          pluralize(snippet.errors.count, "error")
          plain " prohibited this snippet from being saved:"
        end
        ul do
          snippet.errors.each do |error|
            li { error.full_message }
            whitespace
          end
        end
      end
    end
  end
end

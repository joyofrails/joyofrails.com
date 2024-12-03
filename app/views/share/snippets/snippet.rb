module Share
  module Snippets
    class Snippet < ApplicationComponent
      include Phlex::Rails::Helpers::DOMID

      attr_accessor :current_user, :snippet, :attributes

      def initialize(snippet, current_user: false, **attributes)
        @snippet = snippet
        @current_user = current_user
        @attributes = attributes
      end

      def view_template
        div(**mix(attributes, class: "section-content", id: dom_id(snippet))) do
          if snippet.title
            h2 { snippet.title }
          end

          if snippet.description
            render Markdown::Safe.new(snippet.description)
          end

          render CodeBlock::Snippet.new(snippet)

          div(class: "keep-style-when-linked") do
            render Pages::Timestamp.new \
              published_on: snippet.created_at.to_date,
              class: "text-small"
          end

          div do
            render Share::Snippets::Toolbar.new(snippet, current_user: current_user)
          end
        end
      end
    end
  end
end

module Author
  module Snippets
    class Snippet < ApplicationComponent
      include Phlex::Rails::Helpers::DOMID

      attr_accessor :current_user, :snippet, :href, :attributes

      def initialize(snippet, current_user:, href: false, **attributes)
        @snippet = snippet
        @href = href
        @current_user = current_user
        @attributes = attributes
      end

      def view_template
        div(**mix(attributes, class: "section-content", id: dom_id(snippet))) do
          if href
            a(href: href) do
              div(class: "section-content overflow-x-auto keep-style-when-linked") do
                content
              end
            end
          else
            content
          end

          div do
            render Author::Snippets::Toolbar.new(snippet, current_user: current_user)
          end
        end
      end

      def content
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
            updated_on: snippet.updated_at.to_date,
            class: "text-small"
        end
      end
    end
  end
end

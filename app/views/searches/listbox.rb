module Searches
  class Listbox < ApplicationComponent
    include Phlex::Rails::Helpers::DOMID

    attr_reader :pages, :query

    def initialize(pages: [], query: "")
      @pages = pages
      @query = query
    end

    def view_template
      ul(**mix(
        id: "search-listbox",
        role: "listbox",
        class: ["grid"],
        data: {
          controller: "search-listbox"
        }
      )) do
        if pages.any?
          pages.each.with_index do |page, i|
            li(role: "option", id: dom_id(page, "search-option"), class: "rounded") do
              a(
                href: page.request_path,
                data: {
                  turbo_frame: "_top"
                },
                class: ["p-2", "block"]
              ) do
                div(class: "font-semibold") { raw safe(page.title_snippet) }
                div(class: "text-sm") { raw safe(page.body_snippet) }
              end
            end
          end
        elsif query_long_enough?
          li(class: "p-2") do
            p(class: "pb-2") { "No results 😬" }
            p(class: "pb-2 step--2") do
              "Search function is new, bear with me 🧸."
            end
            p(class: "step--2") do
              plain "Please"
              whitespace
              a(href: "/contact") { "reach out" }
              whitespace
              plain "if you’d like to see me address an unlisted topic."
            end
          end
        end
      end
    end

    def query_long_enough?
      query && query.length > 2
    end
  end
end

module Searches
  class Results < ApplicationComponent
    attr_reader :pages, :params, :listbox_attributes

    def initialize(pages:, params:, listbox: {id: "search-results"})
      @pages = pages
      @params = params
      @listbox_attributes = listbox
    end

    def view_template
      div do
        if pages.any?
          ul(**mix(listbox_attributes, role: "listbox", class: "grid")) do
            pages.each.with_index do |page, i|
              li(role: "option") do
                a(
                  href: page.request_path,
                  data: {
                    turbo_frame: "_top"
                  },
                  class: ["p-2", "block", ("selected" if i == 0)]
                ) do
                  page.title
                end
              end
            end
          end
        elsif params[:query] && params[:query].length > 2
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
end

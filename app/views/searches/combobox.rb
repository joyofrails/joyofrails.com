module Searches
  class Combobox < ApplicationComponent
    include Phlex::Rails::Helpers::TurboFrameTag
    include Phlex::Rails::Helpers::FormWith
    include PhlexConcerns::SvgTag

    attr_reader :pages, :query

    def initialize(query: "", pages: [])
      @pages = pages
      @query = query
    end

    def view_template
      div(
        class: "combobox",
        data: {
          controller: "search-combobox",
          action: "
            keydown->search-combobox#navigate
          "
        }
      ) do
        form_with url: search_path,
          method: :get,
          data: {
            controller: "autosubmit-form",
            autosubmit_delay_value: 300,
            turbo_frame: :search
          } do |f|
          div(class: "flex items-center flex-row pl-2") do
            svg_tag "icons/search.svg", class: "w-[32px] fill-current text-theme"
            whitespace
            plain f.search_field :query,
              value: query,
              autofocus: true,
              aria: {
                expanded: false,
                autocomplete: "off",
                controls: "search-results"
              },
              data: {
                action: "autosubmit-form#submit"
              },
              class: "w-full step-1"
          end
        end

        turbo_frame_tag :search do
          div do
            if pages.any?
              ul(**mix(id: "search-results", role: "listbox", class: "grid")) do
                pages.each.with_index do |page, i|
                  li(role: "option") do
                    a(
                      href: page.request_path,
                      data: {
                        turbo_frame: "_top"
                      },
                      class: ["p-2", "block", ("selected" if i == 0)]
                    ) do
                      div(class: "font-semibold") { raw safe(page.title_snippet) }
                      div(class: "text-sm") { raw safe(page.body_snippet) }
                    end
                  end
                end
              end
            elsif query && query.length > 2
              div(class: "p-2") do
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
    end
  end
end

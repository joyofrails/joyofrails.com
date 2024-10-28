module Searches
  class Button < ApplicationComponent
    include PhlexConcerns::SvgTag

    def view_template
      button(
        id: "search-button",
        data: {
          controller: "modal-opener",
          action: "modal-opener#open",
          "modal-opener-dialog-param": "search-dialog"
        },
        type: "button",
        class: ["button ghost focus:ring-gray-200 dark:focus:ring-gray-700 focus:ring-2 focus:outline-none"],
        aria_label: "Open Search Dialog",
        role: "button"
      ) do
        svg_tag "icons/search.svg",
          class: "w-5 h-5",
          fill: "currentColor",
          title: "Search",
          desc: "Search for articles",
          aria: true
      end
    end
  end
end

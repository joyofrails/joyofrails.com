module Searches
  class Form < ApplicationComponent
    include Phlex::Rails::Helpers::FormWith
    include PhlexConcerns::SvgTag

    attr_reader :query, :aria

    def initialize(query: nil, aria: {})
      @query = query
      @aria = {
        expanded: false,
        autocomplete: "off",
        controls: "search-results"
      }.merge(aria)
    end

    def view_template(&)
      form_with url: search_path,
        method: :get,
        data: {
          controller: "autosubmit-form",
          autosubmit_delay_value: 300,
          turbo_frame: :search
        } do |f|
        div(class: "flex items-center flex-row px-2") do
          svg_tag "icons/search.svg", class: "w-[32px] fill-current text-theme"
          whitespace
          plain f.search_field :query,
            value: query,
            autofocus: true,
            aria: aria,
            data: {
              action: "autosubmit-form#submit"
            },
            class: "w-full step-1"
        end
      end
    end
  end
end

module Searches
  class Combobox < ApplicationComponent
    include Phlex::Rails::Helpers::TurboFrameTag
    include Phlex::Rails::Helpers::FormWith
    include PhlexConcerns::SvgTag

    attr_reader :query, :name, :attributes

    def initialize(query: "", name: "search", **attributes)
      @query = query
      @name = name
      @attributes = attributes
    end

    def view_template
      div(
        class: "combobox grid gap-2",
        data: {
          controller: "search-combobox",
          action: "
            keydown->search-combobox#navigate
            search-listbox:connected->search-combobox#tryOpen
            dialog:close@window->search-combobox#closeInTarget
            dialog:open@window->search-combobox#openInTarget
          "
        }
      ) do
        form_with url: search_path,
          method: :post,
          data: {
            controller: "autosubmit-form",
            autosubmit_delay_value: 300,
            autosubmit_minimum_length_value: 3,
            turbo_frame: :search
          } do |f|
          div(class: "flex items-center flex-row pl-2 col-gap-xs") do
            svg_tag "icons/search.svg", class: "w-[32px] fill-current text-theme"
            label(for: "query", class: "sr-only") { "Query" }
            whitespace
            plain f.search_field :query,
              value: query,
              autofocus: true,
              role: "combobox",
              aria: input_aria,
              id: combobox_dom_id,
              data: {
                action: "
                  focus->combobox#tryOpen
                  input->autosubmit-form#submit
                "
              },
              placeholder: "Search Joy of Rails",
              class: "w-full step-1"
          end

          f.hidden_field :name, value: name
        end

        render Searches::Listbox.new(query:, name:, **attributes)
      end
    end

    def input_aria
      {
        expanded: false,
        autocomplete: "none",
        controls: listbox_dom_id,
        owns: listbox_dom_id,
        haspopup: "listbox",
        activedescendant: ""
      }
    end

    def combobox_dom_id
      "#{name}-combobox"
    end

    def listbox_dom_id
      Searches::Listbox.dom_id(name)
    end
  end
end

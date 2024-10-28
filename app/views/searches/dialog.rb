module Searches
  class Dialog < ApplicationComponent
    include Phlex::Rails::Helpers::FormWith
    include Phlex::Rails::Helpers::TurboFrameTag

    include PhlexConcerns::SvgTag

    def view_template
      render ::Dialog::Layout.new(
        id: "search-dialog",
        "aria-label": "Search",
        class: "max-w-xl p-2 mt-32 mx-auto",
        data: {
          controller: "dialog",
          action: "
            keydown.meta+k@window->dialog#open
            click->dialog#tryClose
          "
        }
      ) do |dialog|
        dialog.body do
          div(
            data: {
              controller: "combolist",
              action: "
                keydown->combolist#navigate
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
              div(class: "flex items-center flex-row px-2") do
                svg_tag "icons/search.svg", class: "w-[32px] fill-current text-theme"
                whitespace
                plain f.search_field :query,
                  autofocus: true,
                  data: {
                    action: "autosubmit-form#submit"
                  },
                  class: "w-full step-1"
              end
            end

            turbo_frame_tag :search
          end
        end
      end
    end
  end
end

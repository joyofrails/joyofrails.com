module Searches
  class Dialog < ApplicationComponent
    include Phlex::Rails::Helpers::TurboFrameTag

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
          render Searches::Combobox.new
        end
      end
    end
  end
end

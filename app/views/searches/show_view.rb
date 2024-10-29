class Searches::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :pages, :params
  def initialize(pages:, params:)
    @pages = pages
    @params = params
  end

  def view_template
    div(
      class: "section-content container py-gap mb-3xl"
    ) do
      div(
        class: "combolist",
        data: {
          controller: "combolist",
          action: "
            keydown->combolist#navigate
          "
        }
      ) do
        render Searches::Form.new(query: params[:query], aria: {expanded: pages.any?, controls: "search-results"})

        turbo_frame_tag :search do
          render Searches::Results.new(pages: pages, params: params, listbox: {id: "search-results"})
        end
      end
    end
  end
end

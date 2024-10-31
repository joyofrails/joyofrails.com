class Searches::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :pages, :query

  def initialize(pages:, query:)
    @pages = pages
    @query = query
  end

  def view_template
    render Pages::Header.new(title: "Search")
    div(
      class: "section-content container py-gap mb-3xl"
    ) do
      render Searches::Combobox.new(pages:, query:)
      render partial: "searches/help"
    end
  end
end

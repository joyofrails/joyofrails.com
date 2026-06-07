class Searches::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :attributes

  def initialize(**attrs)
    @attributes = attrs
  end

  def view_template
    render Pages::Header.new(title: "Search Joy of Rails")
    div(
      class: "section-content container py-gap mb-3xl"
    ) do
      h3 { "Enter your search query" }
      render Searches::Combobox.new(**attributes)
      render Markdown::Base.new(File.read(Rails.root.join("app/views/searches/_help.html.mdrb")))
    end
  end
end

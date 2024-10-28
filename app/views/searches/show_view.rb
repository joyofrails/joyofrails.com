class Searches::ShowView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_reader :pages
  def initialize(pages:)
    @pages = pages
  end

  def view_template
    div(class: "section-content container py-gap mb-3xl") do
      turbo_frame_tag :search do
        div(class: "py-4") do
          if pages.any?
            ul(class: "grid grid-row-2xs") do
              pages.each.with_index do |page, i|
                li do
                  a(
                    href: page.request_path,
                    data: {
                      turbo_frame: "_top"
                    },
                    class: ["px-4", "block", ("selected" if i == 0)]
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
end

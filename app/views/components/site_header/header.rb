module SiteHeader
  class Header < ApplicationComponent
    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::TurboFrameTag
    include PhlexConcerns::SvgTag

    def view_template
      header aria: {label: "header"} do
        div(class: "site-header container") do
          nav(class: "p-2") do
            a href: root_path, class: "logo" do
              svg_tag "joy-logo.svg", class: "fill-current"
              span { "Joy of Rails" }
            end
          end
          turbo_frame_tag :header_navigation,
            src: users_header_navigation_path,
            target: :_top do
            render SiteHeader::Nav.new { "" }
          end
        end
      end
    end
  end
end

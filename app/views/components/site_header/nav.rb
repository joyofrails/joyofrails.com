module SiteHeader
  class Nav < ApplicationComponent
    def view_template
      nav(class: "flex items-stretch px-1 col-gap-3xs") do
        # = header_navigation_link_to "Articles", "/articles"
        yield
        render Searches::Button.new
        render DarkMode::Switch.new
      end
    end
  end
end

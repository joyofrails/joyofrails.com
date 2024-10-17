module SiteHeader
  class Nav < ApplicationComponent
    def view_template
      nav(class: "flex items-stretch px-1") do
        # = header_navigation_link_to "Articles", "/articles"
        yield
        render DarkMode::Switch.new
      end
    end
  end
end

module Searches
  module Results
    class Page < ApplicationComponent
      attr_reader :page

      def initialize(page)
        @page = page
      end

      def view_template
        a(
          href: page.url,
          data: {
            turbo_frame: "_top"
          },
          class: ["p-2", "block"]
        ) do
          div(class: "font-semibold") { raw safe(page.title_snippet) }
          div(class: "text-sm") { raw safe(page.body_snippet) }
        end
      end

      Searches::Result.register(::Page, self)
    end
  end
end

module Pages
  class RefreshSearchIndexJob < ApplicationJob
    class Batch < ApplicationJob
      queue_as :default

      def perform
        Page.published.find_each do |page|
          Pages::RefreshSearchIndexJob.perform_later(page)
        end
      end
    end

    queue_as :default

    def perform(page)
      page.update_in_search_index
    end
  end
end

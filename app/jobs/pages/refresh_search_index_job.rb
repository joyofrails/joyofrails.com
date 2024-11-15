module Pages
  class RefreshSearchIndexJob < ApplicationJob
    def perform
      Page.published.find_each(&:update_in_search_index)
    end
  end
end

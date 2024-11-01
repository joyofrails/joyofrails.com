module Pages
  class SearchIndexRefreshJob < ApplicationJob
    def perform
      Page.refresh_search_index
    end
  end
end

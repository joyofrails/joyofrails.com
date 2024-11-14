module Pages
  class BatchUpsertPagesJob < ApplicationJob
    queue_as :default

    def perform(limit: nil)
      Page.upsert_from_sitepress!(limit: limit)
    end
  end
end

module Pages
  class BatchUpsertPagesJob < ApplicationJob
    queue_as :default

    def perform(limit: nil)
      Page.upsert_collection_from_sitepress!(limit: limit)

      Pages::RefreshSearchIndexJob.perform_later
      Pages::BatchAnalyzeTopicsJob.perform_later
      Pages::BatchEmbeddingJob.perform_later
    end
  end
end

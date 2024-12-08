module Pages
  class BatchUpsertPagesJob < ApplicationJob
    queue_as :default

    def perform(limit: nil)
      Page.upsert_collection_from_sitepress!(limit: limit)

      Pages::RefreshSearchIndexJob::Batch.perform_later
      Pages::AnalyzeTopicsJob::Batch.perform_later
      Pages::EmbeddingJob::Batch.perform_later
    end
  end
end

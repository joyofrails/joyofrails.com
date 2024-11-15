module Pages
  class BatchEmbeddingJob < ApplicationJob
    queue_as :default

    def perform
      Page.find_each do |page|
        Pages::EmbeddingJob.perform_later(page)
      end
    end
  end
end

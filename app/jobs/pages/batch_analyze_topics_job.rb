module Pages
  class BatchAnalyzeTopicsJob < ApplicationJob
    queue_as :default

    def perform
      Page.where(request_path: SitepressArticle.published.map(&:request_path)).find_each do |page|
        Pages::AnalyzeTopicsJob.perform_later(page)
      end
    end
  end
end

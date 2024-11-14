module Pages
  class BatchAnalyzeTopicsJob < ApplicationJob
    queue_as :default

    def perform
      scope = Page.where.missing(:topics)
        .and(Page.where(request_path: SitepressArticle.published.map(&:request_path)))

      scope.find_each do |page|
        Pages::AnalyzeTopicsJob.perform_later(page)
      end
    end
  end
end

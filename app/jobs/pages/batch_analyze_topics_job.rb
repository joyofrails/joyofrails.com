module Pages
  class BatchAnalyzeTopicsJob < ApplicationJob
    queue_as :default

    def perform
      Page.published.where.missing(:topics).find_each do |page|
        Pages::AnalyzeTopicsJob.perform_later(page)
      end
    end
  end
end

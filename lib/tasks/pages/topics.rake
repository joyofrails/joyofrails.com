namespace :pages do
  desc "Analyze topics for published article pages"
  task analyze_topics: :environment do
    Pages::BatchAnalyzeTopicsJob.perform_later
  end
end

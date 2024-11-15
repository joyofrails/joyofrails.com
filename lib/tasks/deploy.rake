namespace :deploy do
  desc "Post deploy script"
  task finish: :environment do
    Pages::RefreshSearchIndexJob.perform_later
    Pages::BatchAnalyzeTopicsJob.perform_later
  end
end

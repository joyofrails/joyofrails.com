namespace :deploy do
  desc "Post deploy script"
  task finish: :environment do
    Pages::SearchIndexRefreshJob.perform_later
  end
end

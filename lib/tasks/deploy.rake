namespace :deploy do
  desc "Post deploy script"
  task finish: :environment do
    Pages::BatchUpsertPagesJob.perform_later
  end
end

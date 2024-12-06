namespace :deploy do
  desc "Post deploy script"
  task finish: :environment do
    Page.primary_author # assert primary author exists

    Pages::BatchUpsertPagesJob.perform_later
  end
end

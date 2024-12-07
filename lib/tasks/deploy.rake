namespace :deploy do
  desc "Post deploy script"
  task finish: :environment do
    Page.primary_author # assert primary author exists

    Page.find_by(request_path: "/deploy/hatchbox")&.update_attribute!(:request_path, "/meta/deployment/hatchbox")

    Pages::BatchUpsertPagesJob.perform_later
  end
end

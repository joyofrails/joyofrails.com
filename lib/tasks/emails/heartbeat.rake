namespace :emails do
  task heartbeat: :environment do
    Emails::HeartbeatJob.perform_now
  end
end

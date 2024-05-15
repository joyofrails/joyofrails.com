namespace :channels do
  task heartbeat: :environment do
    Channels::HeartbeatJob.perform_now
  end
end

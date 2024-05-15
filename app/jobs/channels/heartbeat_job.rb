class Channels::HeartbeatJob < ApplicationJob
  queue_as :default

  def perform
    AdminUser.find_each do |admin_user|
      HeartbeatChannel.broadcast_to \
        admin_user,
        title: "It’s alive!",
        body: "The Action Cable connection is working!"
    end
  end
end

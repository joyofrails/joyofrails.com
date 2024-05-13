class Emails::HeartbeatJob < ApplicationJob
  def perform
    AdminUser.find_each do |admin_user|
      Emails::HeartbeatMailer.with(to: admin_user.email).heartbeat.deliver_later
    end
  end
end

class Notifications::EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    # Enqueue individual deliveries
    event.notifications.each do |notification|
      event.deliver_notification(notification)
    end
  end
end

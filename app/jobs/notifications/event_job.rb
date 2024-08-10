class Notifications::EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    event.deliver_notifications_in_bulk

    # Enqueue individual deliveries
    event.notifications.each do |notification|
      notification.transaction do
        event.deliver_notification(notification)
        notification.touch(:processed_at)
      end
    end
  end
end

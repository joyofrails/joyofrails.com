class Notifications::EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    # Enqueue individual deliveries
    event.notifications.each do |notification|
      notification.transaction do
        event.deliver_notification(notification)
        notification.touch(:processed_at)
      end
    end
  end
end

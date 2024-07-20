class WelcomeNotifier < NotificationEvent
  def self.deliver_to(user, **)
    new(params: {user: user}).deliver(user, **)
  end

  def deliver_notification(notification)
    user = notification.recipient

    if !deliver_to?(user)
      Rails.logger.info "#[#{self.class}] Skipping delivery for: #{user.class.name}##{user.id}"
      Honeybadger.event("empty_notification", notifier: self.class.name, recipient: "#{user.class.name}##{user.id}")
      return false
    end

    Emails::UserMailer.welcome(user).deliver_later
  end

  def deliver_to?(recipient)
    Notification.processed.joins(:notification_event).where(recipient: recipient, notification_event: {type: self.class.name}).count < 1
  end
end

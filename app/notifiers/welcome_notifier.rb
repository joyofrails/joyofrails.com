class WelcomeNotifier < NotificationEvent
  def self.deliver_to(user, **)
    new(params: {user: user}).deliver(user, **)
  end

  def deliver_notification(notification)
    user = notification.recipient

    Emails::UserMailer.welcome(user).deliver_later
  end
end

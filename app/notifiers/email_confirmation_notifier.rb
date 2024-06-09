class EmailConfirmationNotifier < NotificationEvent
  def self.deliver_to(user, **)
    new(params: {user: user}).deliver(user, **)
  end

  def deliver_notification(notification)
    user = notification.recipient
    confirmation_token = user.generate_token_for(:confirmation)

    Emails::UserMailer.confirmation(user, confirmation_token).deliver_later
  end
end

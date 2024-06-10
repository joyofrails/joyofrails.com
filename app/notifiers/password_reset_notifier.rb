class PasswordResetNotifier < NotificationEvent
  def self.deliver_to(user, **)
    new(params: {user: user}).deliver(user, **)
  end

  def deliver_notification(notification)
    user = notification.recipient
    password_reset_token = user.generate_token_for(:password_reset)
    Emails::UserMailer.password_reset(user, password_reset_token).deliver_later
  end
end

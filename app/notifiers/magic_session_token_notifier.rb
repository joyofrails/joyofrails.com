class MagicSessionTokenNotifier < NotificationEvent
  def self.deliver_to(user, **)
    new(params: {user: user}).deliver(user, **)
  end

  def deliver_notification(notification)
    user = notification.recipient
    magic_session_token = user.generate_token_for(:magic_session)
    Emails::MagicSessionMailer.sign_in_link(user, magic_session_token).deliver_later
  end
end

class NewUserNotifier < NotificationEvent
  def self.deliver_to(admin_user, user:, **)
    new(params: {user_id: user.id}).deliver(admin_user, **)
  end

  def deliver_notification(notification)
    admin_user = notification.recipient
    user = User.find(params[:user_id])

    Emails::AdminUserMailer.new_user(admin_user: admin_user, user: user).deliver_later
  end
end

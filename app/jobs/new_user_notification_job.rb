class NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    # Do something later
    NewUserNotifier.deliver_to(AdminUser.all, user: user)
    EmailConfirmationNotifier.deliver_to(user)
  end
end

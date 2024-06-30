class Emails::AdminUserMailer < ApplicationMailer
  def new_user(admin_user:, user:)
    @admin_user = admin_user
    @user = user

    mail to: @admin_user.email, subject: "New Joy of Rails User"
  end
end

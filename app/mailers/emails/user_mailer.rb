class Emails::UserMailer < ApplicationMailer
  default from: "no-reply@joyofrails.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.emails.user_mailer.confirmation.subject
  #
  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token

    mail to: @user.email, subject: "Confirmation Instructions"
  end
end

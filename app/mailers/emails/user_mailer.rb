# frozen_string_literal: true

class Emails::UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.emails.user_mailer.confirmation.subject

  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token

    mail to: @user.confirmable_email, subject: "Confirm your email address"
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token

    mail to: @user.email, subject: "Reset your password"
  end

  def welcome(user, unsubscribe_token = :no_token)
    @user = user
    @unsubscribe_token = unsubscribe_token

    mail to: @user.email, subject: "Welcome to Joy of Rails!"
  end
end

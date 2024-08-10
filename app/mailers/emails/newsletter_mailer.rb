# frozen_string_literal: true

class Emails::NewsletterMailer < ApplicationMailer
  NEWSLETTER_EMAIL = Rails.configuration.settings.emails.broadcast_from_address

  default from: email_address_with_name(
    Rails.configuration.settings.emails.broadcast_from_address,
    "Ross from Joy of Rails"
  )

  def newsletter(newsletter:, user:, unsubscribe_token:)
    @newsletter = newsletter
    @user = user
    @unsubscribe_token = unsubscribe_token

    @unsubscribe_url = unsubscribe_users_newsletter_subscription_url(unsubscribe_token)
    headers["MESSAGE-STREAM"] = "broadcast"
    headers["List-Unsubscribe-Post"] ||= "List-Unsubscribe=One-Click"
    headers["List-Unsubscribe"] = "<#{@unsubscribe_url}>"

    mail(to: user.email, subject: newsletter.title)
  end
end

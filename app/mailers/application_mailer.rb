# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  prepend_view_path "app/views/emails"

  SUPPORT_EMAIL = "hello@joyofrails.com"

  default from: email_address_with_name(SUPPORT_EMAIL, "Joy of Rails")
  layout "emails/mailer"

  def support_email
    email_address_with_name(SUPPORT_EMAIL, "Joy of Rails")
  end

  helper_method :support_email
end

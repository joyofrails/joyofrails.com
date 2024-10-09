# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  prepend_view_path "app/views/emails"

  FROM_ADDRESS = Rails.configuration.x.emails.transactional_from_address
  FROM_NAME = Rails.configuration.x.emails.transactional_from_name

  default from: email_address_with_name(FROM_ADDRESS, FROM_NAME)
  layout "emails/mailer"

  def self.test_recipients
    [Rails.configuration.x.emails.test_recipient].compact
  end

  def support_email
    email_address_with_name(FROM_ADDRESS, FROM_NAME)
  end

  helper_method :support_email
end

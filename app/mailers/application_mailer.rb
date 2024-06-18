class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("hello@joyofrails.com", "Joy of Rails")
  layout "emails/mailer"
end

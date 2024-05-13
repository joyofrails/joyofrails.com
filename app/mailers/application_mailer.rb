class ApplicationMailer < ActionMailer::Base
  default from: "hello@joyofrails.com"
  layout "emails/mailer"
end

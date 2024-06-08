module MailHelpers
  def find_mail_to(email)
    ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email) }
  end
end

RSpec.configure do |config|
  config.include MailHelpers, type: :system
end

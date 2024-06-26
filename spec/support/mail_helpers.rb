module MailHelpers
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def find_mail_to(email)
    ActionMailer::Base.deliveries.find { |mail| mail.to.include?(email) }
  end

  def email_link(email, string)
    raise ArgumentError, "Email is missing" if email.blank?

    document = Capybara.string(email.html_part.body.to_s)
    link = document.find(:link, string)[:href]

    localize_link(link)
  end

  def perform_enqueued_jobs_and_subsequently_enqueued_jobs
    3.times do
      perform_enqueued_jobs
    end
  end

  private

  def localize_link(link)
    uri = URI.parse(link)

    if uri.query
      "#{uri.path}?#{uri.query}"
    else
      uri.path
    end
  end
end

RSpec.configure do |config|
  config.include MailHelpers
end

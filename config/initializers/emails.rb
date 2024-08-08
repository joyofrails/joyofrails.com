Rails.application.configure do
  config.settings.emails = ActiveSupport::OrderedOptions.new

  emails = Rails.application.credentials.emails

  config.settings.emails.transactional_from_address = emails&.transactional_from_address || "hello@example.com"
  config.settings.emails.transactional_from_name = emails&.transactional_from_name || "Joy of Rails"
  config.settings.emails.broadcast_from_address = emails&.broadcast_from_address || "hello@example.com"
  config.settings.emails.broadcast_from_name = emails&.broadcast_from_name || "Joy of Rails"
  config.settings.emails.test_recipient = emails&.test_recipient || "hello@example.com"
end

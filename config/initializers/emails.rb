Rails.application.configure do
  credentials = Rails.application.credentials

  config.x.emails.transactional_from_address = credentials.dig(:transactional_from_address) || "hello@example.com"
  config.x.emails.transactional_from_name = credentials.dig(:transactional_from_name) || "Joy of Rails"
  config.x.emails.broadcast_from_address = credentials.dig(:broadcast_from_address) || "hello@example.com"
  config.x.emails.broadcast_from_name = credentials.dig(:broadcast_from_name) || "Joy of Rails"
  config.x.emails.test_recipient = credentials.dig(:test_recipient) || "hello@example.com"
end

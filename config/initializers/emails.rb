Rails.application.configure do
  config.x.emails.transactional_from_address = credentials.dig(:emails, :transactional_from_address) || "hello@example.com"
  config.x.emails.transactional_from_name = credentials.dig(:emails, :transactional_from_name) || "Joy of Rails"
  config.x.emails.broadcast_from_address = credentials.dig(:emails, :broadcast_from_address) || "hello@example.com"
  config.x.emails.broadcast_from_name = credentials.dig(:emails, :broadcast_from_name) || "Joy of Rails"
  config.x.emails.test_recipient = credentials.dig(:emails, :test_recipient) || "hello@example.com"
end

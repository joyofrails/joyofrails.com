# Create admin user account
AdminUser.find_or_create_by!(
  email: "admin@example.com"
) do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

User.find_or_create_by(
  email: Rails.configuration.x.emails.test_recipient
) do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.confirmed_at = Time.zone.now
end

ColorScheme.find_or_create_default

START_COUNT_NEWSLETTERS = 5
newsletter_fill_count = START_COUNT_NEWSLETTERS - Newsletter.count
FactoryBot.create_list(:newsletter, newsletter_fill_count) if newsletter_fill_count > 0

SNIPPET_COUNT = 10
snippet_fill_count = SNIPPET_COUNT - Snippet.count
FactoryBot.create_list(:snippet, snippet_fill_count) if snippet_fill_count > 0

# Enable all flags by default
Flipper.enable(:user_registration)
Flipper.enable(:snippets)
Flipper.enable(:example_posts)

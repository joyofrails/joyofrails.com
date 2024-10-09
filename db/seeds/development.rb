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
fill_count = START_COUNT_NEWSLETTERS - Newsletter.count
FactoryBot.create_list(:newsletter, fill_count) if fill_count > 0

# Enable all flags by default
Flipper.enable(:user_registration)
Flipper.enable(:snippets)
Flipper.enable(:example_posts)

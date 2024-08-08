# Create admin user account
AdminUser.find_or_create_by!(
  email: "admin@example.com"
) do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

User.find_or_create_by(
  email: "joy@example.com"
) do |u|
  u.password = "password"
  u.password_confirmation = "password"
  u.confirmed_at = Time.zone.now
end

ColorScheme.find_or_create_default

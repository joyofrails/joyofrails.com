# Create admin user account
AdminUser.find_or_create_by!(
  email: "admin@example.com"
) do |u|
  password = "password"
  u.password = password
  u.password_confirmation = password
end

ColorScheme.find_or_create_default

# Create admin user account
AdminUser.find_or_create_by!(
  email: Rails.application.credentials.seeds.admin_email
) do |u|
  password = Rails.application.credentials.seeds.admin_password
  u.password = password
  u.password_confirmation = password
end

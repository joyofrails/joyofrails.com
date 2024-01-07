# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
if File.exist?(Rails.root.join("db", "seeds", "#{Rails.env}.rb"))
  puts "Loading #{Rails.env} seeds..."
  require Rails.root.join("db", "seeds", "#{Rails.env}.rb")
end

# Create admin user account
AdminUser.find_or_create_by!(
  email: ENV.fetch("ADMIN_EMAIL")
) do |u|
  u.password = ENV.fetch("ADMIN_PASSWORD")
  u.password_confirmation = ENV.fetch("ADMIN_PASSWORD")
end

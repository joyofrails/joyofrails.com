RSpec.configure do |config|
  config.before do
    Flipper.add(:pwa_showcase_navigation)
    Flipper.add(:user_registration)
  end
end

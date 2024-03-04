RSpec.configure do |config|
  config.before do
    Flipper.add(:pwa_showcase_navigation)
  end
end

module WardenHelpers
  def login_admin_user(admin_user = FactoryBot.create(:admin_user))
    login_as(admin_user, scope: :admin_user)
    admin_user
  end

  def login_user(user = FactoryBot.create(:user))
    login_as(user, scope: :user)
    user
  end
end

RSpec.configure do |config|
  config.include WardenHelpers, type: :request
  config.include WardenHelpers, type: :system

  config.before(:each) do
    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
  end
end

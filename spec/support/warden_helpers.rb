module WardenHelpers
  def login_admin_user(admin_user = FactoryBot.create(:admin_user))
    login_as(admin_user, scope: :admin_user)
  end
end

RSpec.configure do |config|
  config.include WardenHelpers, type: :request
  config.include WardenHelpers, type: :system
end

# Preview all emails at http://localhost:3000/rails/mailers/admin_user
class Emails::AdminUserMailerPreview < ActionMailer::Preview
  def new_user
    Emails::AdminUserMailer.new_user(admin_user: FactoryBot.build(:admin_user), user: FactoryBot.build(:user))
  end
end

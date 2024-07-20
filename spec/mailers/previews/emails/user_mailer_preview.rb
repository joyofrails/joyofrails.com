# Preview all emails at http://localhost:3000/rails/mailers/emails/user
class Emails::UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/emails/user/confirmation
  def confirmation
    Emails::UserMailer.confirmation(FactoryBot.build(:user), "confirmation_token")
  end

  def password_reset
    Emails::UserMailer.password_reset(FactoryBot.build(:user), "password_reset_token")
  end

  def welcome
    Emails::UserMailer.welcome(FactoryBot.build(:user))
  end
end

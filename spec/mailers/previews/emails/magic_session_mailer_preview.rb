# Preview all emails at http://localhost:3000/rails/mailers/magic_session
class Emails::MagicSessionMailerPreview < ActionMailer::Preview
  def sign_in_link
    Emails::MagicSessionMailer.sign_in_link(FactoryBot.build(:user), "magic_session_token")
  end

  def no_account_found
    Emails::MagicSessionMailer.no_account_found("user@example.com")
  end
end

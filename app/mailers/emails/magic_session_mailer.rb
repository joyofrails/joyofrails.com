class Emails::MagicSessionMailer < ApplicationMailer
  def sign_in_link(user, magic_session_token)
    @user = user
    @magic_session_token = magic_session_token

    mail to: @user.email, subject: "Your sign-in link"
  end

  def no_account_found(email)
    mail to: email, subject: "No account found", support_email: support_email
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/emails/user
class Emails::UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/emails/user/confirmation
  def confirmation
    Emails::UserMailer.confirmation
  end
end

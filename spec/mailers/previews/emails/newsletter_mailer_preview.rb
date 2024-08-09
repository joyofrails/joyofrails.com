# Preview all emails at http://localhost:3000/rails/mailers/newsletter_mailer
class Emails::NewsletterMailerPreview < ActionMailer::Preview
  def newsletter
    Emails::NewsletterMailer.newsletter(
      newsletter: FactoryBot.build(:newsletter),
      user: FactoryBot.build(:user),
      unsubscribe_token: "unsubscribe_token"
    )
  end
end

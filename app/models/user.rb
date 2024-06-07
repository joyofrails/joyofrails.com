class User < ApplicationRecord
  has_one :pending_unconfirmed_email, -> { pending }, dependent: :destroy
  has_many :unconfirmed_emails, dependent: :destroy

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.downcase.strip }

  has_secure_password

  generates_token_for :confirmation, expires_in: 6.hours
  generates_token_for :password_reset, expires_in: 10.minutes

  def confirmable_email
    if pending_unconfirmed_email.present?
      pending_unconfirmed_email.email
    else
      email
    end
  end

  def reconfirming?
    pending_unconfirmed_email.present?
  end

  def needs_confirmation?
    unconfirmed? || reconfirming?
  end

  def confirm!
    return false unless needs_confirmation?

    if reconfirming?
      return transaction do
        update(email: pending_unconfirmed_email.email)
        unconfirmed_emails.archive!
      end
    end

    update_column(:confirmed_at, Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_email!
    confirmation_token = generate_token_for(:confirmation)
    Emails::UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def send_password_reset_email!
    password_reset_token = generate_token_for(:password_reset)
    Emails::UserMailer.password_reset(self, password_reset_token).deliver_now
  end
end

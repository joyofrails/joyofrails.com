class AdminUser < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes

  has_secure_password

  before_save { self.email = email.downcase }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  def confirm!
    update_column(:confirmed_at, Time.zone.now)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id(expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirmation_email)
  end
end

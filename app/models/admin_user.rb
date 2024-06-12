class AdminUser < ApplicationRecord
  has_secure_password

  before_save { self.email = email.downcase }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  def confirmed?
    true
  end

  def unconfirmed? = !confirmed?
  alias_method :needs_confirmation?, :unconfirmed?
end

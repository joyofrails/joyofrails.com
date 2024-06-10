class User < ApplicationRecord
  attr_reader :current_password

  has_one :pending_unconfirmed_email, -> { pending }, dependent: :destroy, class_name: "UnconfirmedEmail"
  has_many :unconfirmed_emails, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  normalizes :email, with: ->(email) { email.downcase.strip }

  has_secure_password

  generates_token_for :confirmation, expires_in: 6.hours
  generates_token_for :password_reset, expires_in: 10.minutes

  accepts_nested_attributes_for :unconfirmed_emails, reject_if: :reject_unconfirmed_emails, limit: 1

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

  def unconfirmed? = !confirmed?

  def reject_unconfirmed_emails(attributes)
    attributes["email"].blank?
  end
end

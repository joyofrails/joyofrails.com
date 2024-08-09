class User < ApplicationRecord
  attr_accessor :subscribing

  has_secure_password

  has_one :pending_email_exchange, -> { pending }, dependent: :destroy, class_name: "EmailExchange"
  has_many :email_exchanges, dependent: :destroy

  has_one :newsletter_subscription, as: :subscriber, dependent: :destroy

  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :recently_confirmed, -> { where("confirmed_at > ?", 2.weeks.ago) }
  scope :subscribers, -> { confirmed.joins(:newsletter_subscription) }
  scope :test_recipients, -> { where(email: ApplicationMailer.test_recipients) }

  accepts_nested_attributes_for :email_exchanges, limit: 1

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}

  normalizes :email, with: ->(email) { email.downcase.strip }

  generates_token_for :confirmation, expires_in: 6.hours
  generates_token_for :password_reset, expires_in: 10.minutes
  generates_token_for :magic_session, expires_in: 1.hour do
    last_sign_in_at
  end

  def confirmable_email
    if pending_email_exchange.present?
      pending_email_exchange.email
    else
      email
    end
  end

  def reconfirming?
    pending_email_exchange.present?
  end

  def needs_confirmation?
    unconfirmed? || reconfirming?
  end

  def confirm!
    return false unless needs_confirmation?

    if reconfirming?
      transaction do
        update(email: pending_email_exchange.email)
        email_exchanges.archive!
      end
    end

    touch :confirmed_at
  end

  def signed_in!
    touch :last_sign_in_at
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed? = !confirmed?

  def subscribed_to_newsletter? = !!newsletter_subscription&.persisted?

  # We want built-in validations provided by has_secure_password but to make
  # room for users who are only subscribing for newsletter content, we need to
  # bypass the presence validations for password when subscribing.
  # This techinque is a bit of a hack though it is suggested by the Rails docs
  # for has_secure_password
  # https://api.rubyonrails.org/v7.1.3/classes/ActiveModel/SecurePassword/ClassMethods.html
  def errors
    super.tap { |errors| errors.delete(:password, :blank) if subscribing }
  end
end

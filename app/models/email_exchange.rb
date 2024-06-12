class EmailExchange < ApplicationRecord
  belongs_to :user

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.downcase.strip }

  enum :status, {pending: 0, archived: 1}, default: :pending

  def self.archive!
    update_all(status: :archived)
  end
end

# == Schema Information
#
# Table name: email_exchanges
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  status     :string           default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string           not null
#
# Indexes
#
#  index_email_exchanges_on_user_id            (user_id)
#  index_email_exchanges_on_user_id_and_email  (user_id,email) UNIQUE WHERE status = 0
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class EmailExchange < ApplicationRecord
  belongs_to :user

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  normalizes :email, with: ->(email) { email.downcase.strip }

  enum :status, {pending: 0, archived: 1}, default: :pending

  def self.archive!
    update_all(status: :archived)
  end
end

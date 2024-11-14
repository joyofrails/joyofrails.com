# == Schema Information
#
# Table name: admin_users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#
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

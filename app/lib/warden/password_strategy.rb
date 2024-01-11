require "warden"

class PasswordStrategy < ::Warden::Strategies::Base
  def valid?
    scoped_params["email"] && scoped_params["password"]
  end

  def authenticate!
    user = AdminUser.authenticate(email: scoped_params["email"], password: scoped_params["password"])
    user.nil? ? fail!("Could not log in") : success!(user)
  end

  def scoped_params
    params[scope.to_s] || {}
  end
end

::Warden::Strategies.add(:password, PasswordStrategy)

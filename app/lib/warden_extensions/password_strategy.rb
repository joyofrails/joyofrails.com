module WardenExtensions
  class PasswordStrategy < ::Warden::Strategies::Base
    def valid?
      scoped_params["email"] && scoped_params["password"]
    end

    def authenticate!
      user = scope_class.authenticate_by(email: scoped_params["email"].to_s.downcase, password: scoped_params["password"])

      return fail!(:invalid) if !user
      return fail!(:unconfirmed) if user.needs_confirmation?

      success!(user)
    end

    def scoped_params
      params[scope.to_s] || {}
    end

    def scope_class
      scope.to_s.classify.constantize
    end
  end
end

::Warden::Strategies.add(:password, WardenExtensions::PasswordStrategy)

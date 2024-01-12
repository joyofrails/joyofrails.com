module WardenExtensions
  class PasswordStrategy < ::Warden::Strategies::Base
    def valid?
      scoped_params["email"] && scoped_params["password"]
    end

    def authenticate!
      user = scope_class.authenticate(email: scoped_params["email"], password: scoped_params["password"])
      user ? success!(user) : fail!(:invalid)
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

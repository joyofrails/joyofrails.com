module WardenExtensions::Strategies
  class Password < ::Warden::Strategies::Base
    def self.key
      name.demodulize.underscore.to_sym
    end

    def key
      self.class.key
    end

    def valid?
      !!(scoped_params["email"] && scoped_params["password"])
    end

    def authenticate!
      user = scope_class.authenticate_by(email: scoped_params["email"].to_s.downcase, password: scoped_params["password"])

      return fail!(:invalid) if !user
      return fail!(:unconfirmed) if user.needs_confirmation?

      success!(user)
    end

    private

    def scoped_params
      params[scope.to_s] || params
    end

    def scope_class
      return User unless scope
      scope.to_s.classify.constantize
    end
  end
end

::Warden::Strategies.add(:password, WardenExtensions::Strategies::Password)

module WardenExtensions
  class MagicSessionStrategy < ::Warden::Strategies::Base
    def valid?
      !!token
    end

    def authenticate!
      user = scope_class.find_by_token_for(:magic_session, token)

      return fail!(:invalid) if !user
      return fail!(:unconfirmed) if user.needs_confirmation?

      success!(user)
    end

    private

    def token
      params["token"]
    end

    def scope_class
      return User unless scope
      scope.to_s.classify.constantize
    end
  end
end

::Warden::Strategies.add(:magic_session, WardenExtensions::MagicSessionStrategy)

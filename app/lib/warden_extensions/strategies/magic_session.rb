module WardenExtensions::Strategies
  class MagicSession < ::Warden::Strategies::Base
    def self.key
      name.demodulize.underscore.to_sym
    end

    def key
      self.class.key
    end

    def valid?
      !!token
    end

    def authenticate!
      user = scope_class.find_by_token_for(:magic_session, token)

      return fail!(:invalid) if !user

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

::Warden::Strategies.add(:magic_session, WardenExtensions::Strategies::MagicSession)

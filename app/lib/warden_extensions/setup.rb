module WardenExtensions
  module Setup
    module_function

    def configure_manager
      Warden::Manager.serialize_into_session do |user|
        [user.class.name, user.id]
      end

      Warden::Manager.serialize_from_session do |(class_name, id)|
        class_name.constantize.find(id)
      end

      Warden::Manager.after_authentication do |user, auth, opts|
        case opts[:scope]
        when :user
          user.signed_in!
        when :admin_user
          # no op
        end

        case auth.winning_strategy&.key
        when :magic_session
          user.confirm!
          WelcomeNotifier.deliver_to(user)
        when :password
          # no op
        else # nil, as with test helpers
          # no op
        end
      end
    end
  end
end

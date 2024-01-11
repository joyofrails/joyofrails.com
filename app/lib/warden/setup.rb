require "warden"

Warden::Manager.serialize_into_session do |user|
  [user.class.name, user.id]
end

Warden::Manager.serialize_from_session do |(class_name, id)|
  class_name.constantize.find(id)
end

# Hooks
# Warden::Manager.after_set_user do |user, auth, opts|
#   unless user.active?
#     auth.logout
#     throw(:warden, :message => "User not active")
#   end
# end

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    rescue_from StandardError, with: :report_error

    identified_by :current_admin_user

    def connect
      self.current_admin_user = find_verified_admin_user
      logger.add_tags "ActionCable", current_admin_user.id
    end

    private

    def find_verified_admin_user
      env["warden"].user(scope: :admin_user) || reject_unauthorized_connection
    end

    private

    def report_error(e)
      Rails.logger.error(e)
      Honeybadger.notify(e)
    end
  end
end

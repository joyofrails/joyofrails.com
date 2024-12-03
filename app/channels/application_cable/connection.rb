module ApplicationCable
  class Connection < ActionCable::Connection::Base
    rescue_from StandardError, with: :report_error

    identified_by :current_user

    def connect
      self.current_user = find_current_user
      logger.add_tags "ActionCable", current_user.id
    end

    private

    def find_current_user
      env["warden"]&.user(scope: :user) || Guest.new
    end

    def report_error(e)
      Rails.logger.error(e)
      Honeybadger.notify(e)
    end
  end
end

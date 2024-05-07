# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_admin_user
    helper_method :current_admin_user
    helper_method :admin_user_signed_in?
  end

  def warden
    request.env["warden"]
  end

  def redirect_admin_if_authenticated
    redirect_to admin_root_path, alert: "You are already logged in." if admin_user_signed_in?
  end

  protected

  def current_admin_user
    Current.admin_user ||= warden.user(scope: :admin_user)
  end

  def admin_user_signed_in?
    Current.admin_user.present?
  end
end

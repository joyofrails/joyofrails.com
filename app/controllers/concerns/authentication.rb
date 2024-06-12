# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_admin_user
    before_action :current_user

    helper_method :current_admin_user
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :admin_user_signed_in?
  end

  def warden
    request.env["warden"]
  end

  def authenticate_user!
    store_location
    redirect_to new_users_session_path, alert: "You need to login to access that page" unless user_signed_in?
  end

  def redirect_admin_if_authenticated
    redirect_to admin_root_path, alert: "You are already logged in." if admin_user_signed_in?
  end

  def redirect_if_authenticated
    redirect_back fallback_location: login_success_path, alert: "You are already logged in." if user_signed_in?
  end

  protected

  def login_success_path
    session.delete(:user_return_to) || users_dashboard_path
  end

  def current_user
    Current.user ||= warden.user(scope: :user)
  end

  def current_admin_user
    Current.admin_user ||= warden.user(scope: :admin_user)
  end

  def user_signed_in?
    current_user.present?
  end

  def admin_user_signed_in?
    current_admin_user.present?
  end

  def store_location
    session[:user_return_to] = request.original_url if request.get? && request.local?
  end
end

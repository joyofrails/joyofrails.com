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
    redirect_to root_path if !user_signed_in?
  end

  def redirect_admin_if_authenticated
    redirect_to admin_root_path, alert: "You are already logged in." if admin_user_signed_in?
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if user_signed_in?
  end

  protected

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
end

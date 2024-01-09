# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_admin_user
    helper_method :current_admin_user
    helper_method :admin_user_signed_in?
  end

  def login(admin_user)
    reset_session
    session[:current_admin_user_id] = admin_user.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated
    redirect_to root_path, alert: "You are already logged in." if admin_user_signed_in?
  end

  private

  def current_admin_user
    Current.admin_user ||= session[:current_admin_user_id] && AdminUser.find_by(id: session[:current_admin_user_id])
  end

  def admin_user_signed_in?
    Current.admin_user.present?
  end
end

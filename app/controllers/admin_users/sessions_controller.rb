class AdminUsers::SessionsController < ApplicationController
  before_action :redirect_admin_if_authenticated, only: [:create, :new]

  def new
  end

  def create
    warden.authenticate!(:password, scope: :admin_user)

    redirect_to admin_root_path, notice: "Signed in successfully."
  end

  def destroy
    warden.logout(:admin_user)
    warden.clear_strategies_cache!(scope: :admin_user)

    redirect_to new_admin_users_session_path, notice: "Signed out successfully."
  end

  def fail
    warden_options = request.env["warden.options"] || {}
    warden_message = warden_options[:message]

    if warden_message == :invalid
      flash.now[:alert] = "Incorrect email or password."
    end

    render :new, status: :unprocessable_entity
  end
end

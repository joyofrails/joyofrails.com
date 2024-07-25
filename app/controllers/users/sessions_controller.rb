# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  before_action :feature_enabled!
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:destroy]

  def new
    render Users::Sessions::NewView.new
  end

  def create
    @user = warden.authenticate!(scope: :user)

    redirect_to login_success_path, notice: "Signed in successfully"
  end

  def destroy
    warden.logout(:user)
    warden.clear_strategies_cache!(scope: :user)

    redirect_to root_path, notice: "Signed out successfully"
  end

  # This method is called when Warden authentication fails
  def fail
    warden_options = request.env["warden.options"] || {}
    warden_message = warden_options[:message]

    message = case warden_message
    when :invalid
      "Incorrect email or password"
    when :unconfirmed
      "Please confirm your email address first"
    end

    flash.now[:alert] = message

    email = params.require(:user).permit(:email)[:email].to_s.downcase
    user = User.new(email: email)

    render Users::Sessions::NewView.new(user: user), status: :unprocessable_entity
  end

  private

  def feature_enabled!
    unless Flipper.enabled?(:user_registration, current_admin_user)
      redirect_to root_path,
        notice: "Coming soon!"
    end
  end
end

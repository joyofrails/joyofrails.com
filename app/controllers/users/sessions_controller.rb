class Users::SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
    render Users::Sessions::NewView.new
  end

  def create
    if User.find_by(email: params[:user][:email].downcase).unconfirmed?
      return redirect_to new_users_confirmation_path, alert: "Please confirm your email address first."
    end

    warden.authenticate!(:password, scope: :user)

    redirect_to login_success_path, notice: "Signed in."
  end

  def destroy
    warden.logout(:user)
    warden.clear_strategies_cache!(scope: :user)

    redirect_to root_path, notice: "Signed out successfully."
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

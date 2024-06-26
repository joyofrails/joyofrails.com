# frozen_string_literal: true

class Users::PasswordsController < ApplicationController
  before_action :feature_enabled!
  before_action :redirect_if_authenticated

  def new
    render Users::Passwords::NewView.new(user: User.new)
  end

  def create
    email = params.require(:user).permit(:email).dig(:email).to_s.downcase
    @user = User.find_by(email: email)

    if @user.blank?
      return redirect_to new_users_session_path, notice: "If that user exists we’ve sent instructions to their email"
    end

    if @user.unconfirmed?
      return redirect_to new_users_confirmation_path, alert: "Please confirm your email address first"
    end

    PasswordResetNotifier.deliver_to(@user)

    redirect_to new_users_session_path, notice: "If that user exists we’ve sent instructions to their email"
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:token])

    if @user.blank?
      return redirect_to new_users_password_path, alert: "That link is invalid or expired"
    end

    if @user.unconfirmed?
      return redirect_to new_users_confirmation_path, alert: "You must confirm your email before you can sign in"
    end

    render Users::Passwords::EditView.new(user: @user, password_reset_token: params[:token])
  end

  def update
    @user = User.find_by_token_for(:password_reset, params[:token])

    if @user.blank?
      flash.now[:alert] = "That link is invalid or expired"
      return render Users::Passwords::NewView.new(user: User.new), status: :unprocessable_entity
    end

    if @user.unconfirmed?
      return redirect_to new_users_confirmation_path, alert: "Please confirm your email before you can sign in"
    end

    if @user.update(password_params)
      redirect_to new_users_session_path, notice: "Password updated! Please sign in"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render Users::Passwords::EditView.new(user: @user, password_reset_token: params[:token]), status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def feature_enabled!
    redirect_to root_path, notice: "Coming soon!" unless Flipper.enabled?(:user_registration, current_admin_user)
  end
end

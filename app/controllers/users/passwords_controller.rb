# app/controllers/passwords_controller.rb
class PasswordsController < ApplicationController
  before_action :redirect_if_authenticated

  def new
    render Users::Passwords::NewView.new
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user.present?
      if @user.confirmed?
        @user.send_password_reset_email!
        redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
      else
        redirect_to new_users_confirmation_path, alert: "Please confirm your email first."
      end
    else
      redirect_to root_path, notice: "If that user exists we've sent instructions to their email."
    end
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:password_reset_token])
    if @user.present? && @user.unconfirmed?
      redirect_to new_users_confirmation_path, alert: "You must confirm your email before you can sign in."
    elsif @user.nil?
      redirect_to new_users_password_path, alert: "Invalid or expired token."
    end
  end

  def update
    @user = User.find_by_token_for(:password_reset, params[:password_reset_token])
    if @user
      if @user.unconfirmed?
        redirect_to new_users_confirmation_path, alert: "You must confirm your email before you can sign in."
      elsif @user.update(password_params)
        redirect_to new_users_sessions_path, notice: "Sign in."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Invalid or expired token."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

# frozen_string_literal: true

class Users::ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
    @user = User.new
    render Users::Confirmations::NewView.new(user: @user)
  end

  def create
    email = params.require(:user).permit(:email).dig(:email).to_s.downcase
    @user = User.find_by(email: email)

    if @user.blank?
      return redirect_to new_users_confirmation_path, alert: "We are unable to confirm that email address"
    end

    if !@user.needs_confirmation?
      return redirect_to root_path, notice: "Your account has already been confirmed"
    end

    EmailConfirmationNotifier.deliver_to(@user)

    redirect_to root_path, notice: "Check your email for confirmation instructions"
  end

  def edit
    @user = User.find_by_token_for(:confirmation, params[:token])

    if @user.blank?
      return redirect_to new_users_confirmation_path, alert: "This link is invalid or expired"
    end

    if !@user.needs_confirmation?
      return redirect_to root_path, notice: "Your account has already been confirmed"
    end

    render Users::Confirmations::EditView.new(user: @user, confirmation_token: params[:token])
  end

  def update
    @user = User.find_by_token_for(:confirmation, params[:token])

    if @user.blank?
      return redirect_to new_users_confirmation_path, alert: "That link is invalid or expired"
    end
    if !@user.needs_confirmation?
      return redirect_to root_path, notice: "Your account has already been confirmed"
    end

    if @user.confirm!
      if Flipper.enabled?(:user_registration, @user)
        warden.set_user(@user, scope: :user)
      end

      WelcomeNotifier.deliver_to(@user)

      redirect_to users_thank_you_path, notice: "Thank you for confirming your email address"
    else
      redirect_to new_users_confirmation_path, alert: "Something went wrong"
    end
  end
end

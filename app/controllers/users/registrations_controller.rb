# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  invisible_captcha only: [:create]

  before_action :feature_enabled!
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def new
    user = User.new
    render Users::Registrations::NewView.new(user: user)
  end

  def create
    create_user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    user = User.new(create_user_params)
    if user.save
      NewUserNotifier.deliver_to(AdminUser.all, user: user)
      EmailConfirmationNotifier.deliver_to(user)

      redirect_to thanks_users_registration_path, notice: "Welcome to Joy of Rails! Please check your email for confirmation instructions"
    else
      render Users::Registrations::NewView.new(user: user), status: :unprocessable_entity
    end
  end

  def edit
    user = current_user
    user.email_exchanges.build

    render Users::Registrations::EditView.new(user: user)
  end

  def update
    update_user_params = params.require(:user).permit(:password_challenge, :password, :password_confirmation, email_exchanges_attributes: [:email])

    user = current_user

    if !user.authenticate(params[:user][:password_challenge])
      flash.now[:error] = "Incorrect password"
      return render Users::Registrations::EditView.new(user: user), status: :unprocessable_entity
    end

    if !user.update(update_user_params)
      return render Users::Registrations::EditView.new(user: user), status: :unprocessable_entity
    end

    if update_user_params[:email_exchanges_attributes].present?
      EmailConfirmationNotifier.deliver_to(user)
      redirect_to users_dashboard_path, notice: "Check your email for confirmation instructions"
    else
      redirect_to users_dashboard_path, notice: "Account updated"
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted"
  end

  def thanks
    render Users::Dashboard::IndexView.new
  end

  private

  def feature_enabled!
    redirect_to root_path, notice: "Coming soon!" unless Flipper.enabled?(:user_registration, current_admin_user)
  end
end

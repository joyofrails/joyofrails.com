# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def new
    @user = User.new
    render Users::Registrations::NewView.new(user: @user)
  end

  def create
    create_user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = User.new(create_user_params)
    if @user.save
      EmailConfirmationNotifier.deliver_to(@user)
      redirect_to root_path, notice: "Welcome to Joy of Rails! Please check your email for confirmation instructions"
    else
      render Users::Registrations::NewView.new(user: @user), status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
    @user.email_exchanges.build

    render Users::Registrations::EditView.new(user: @user)
  end

  def update
    update_user_params = params.require(:user).permit(:current_password, :password, :password_confirmation, email_exchanges_attributes: [:email])

    @user = current_user

    if !@user.authenticate(params[:user][:current_password])
      flash.now[:error] = "Incorrect password"
      return render Users::Registrations::EditView.new(user: @user), status: :unprocessable_entity
    end

    if !@user.update(update_user_params)
      return render Users::Registrations::EditView.new(user: @user), status: :unprocessable_entity
    end

    if update_user_params[:email_exchanges_attributes].present?
      EmailConfirmationNotifier.deliver_to(@user)
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
end

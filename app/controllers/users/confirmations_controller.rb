class Users::ConfirmationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
    @user = User.new
    render Users::Confirmations::NewView.new(user: @user)
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Check your email for confirmation instructions"
    else
      redirect_to new_users_confirmations_path, alert: "We could not find a user with that email or that email has already been confirmed"
    end
  end

  def edit
    @user = User.find_by_token_for(:confirmation, params[:confirmation_token])

    if !@user.present?
      return redirect_to new_users_confirmations_path, alert: "Invalid token"
    end
    if !@user.needs_confirmation?
      return redirect_to root_path, notice: "Your account has already been confirmed"
    end

    render Users::Confirmations::EditView.new(user: @user, confirmation_token: params[:confirmation_token])
  end

  def update
    @user = User.find_by_token_for(:confirmation, params[:confirmation_token])

    if @user.blank?
      return redirect_to new_users_confirmations_path, alert: "Invalid token"
    end
    if !@user.needs_confirmation?
      return redirect_to root_path, notice: "Your account has already been confirmed"
    end

    if @user.confirm!
      warden.set_user(@user, scope: :user)

      redirect_to users_dashboard_path, notice: "Your account has been confirmed"
    else
      redirect_to new_users_confirmations_path, alert: "Something went wrong"
    end
  end
end

# app/controllers/users_controller.rb
class Users::RegistrationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to users_dashboard_path, notice: "Please check your email for confirmation instructions."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
    render Users::Registrations::NewView.new(user: @user)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

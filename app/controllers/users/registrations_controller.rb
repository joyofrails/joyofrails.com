# app/controllers/users_controller.rb
class Users::RegistrationsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
    @user = User.new
    render Users::Registrations::NewView.new(user: @user)
  end

  def create
    create_user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = User.new(create_user_params)
    if @user.save
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Welcome to Joy of Rails! Please check your email for confirmation instructions."
    else
      render Users::Registrations::NewView.new(user: @user), status: :unprocessable_entity
    end
  end

  def update
    update_user_params = params.require(:user).permit(:current_password, :password, :password_confirmation, unconfirmed_emails_attributes: [:email])

    @user = current_user

    if !@user.authenticate(params[:user][:current_password])
      flash.now[:error] = "Incorrect password"
      return render :edit, status: :unprocessable_entity
    end

    if !@user.update(update_user_params)
      return render :edit, status: :unprocessable_entity
    end

    if params[:user][:unconfirmed_emails_attributes].present?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to root_path, notice: "Account updated."
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end
end

class AdminUsers::SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def new
  end

  def create
    warden.authenticate!(:password, scope: :admin_user)

    redirect_to root_path, notice: "Signed in successfully."
  end

  def destroy
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

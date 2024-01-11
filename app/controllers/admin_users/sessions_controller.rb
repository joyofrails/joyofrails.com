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
end

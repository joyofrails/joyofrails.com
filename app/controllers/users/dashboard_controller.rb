class Users::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render Users::Dashboard::IndexView.new
  end
end

class Users::HeaderNavigationsController < ApplicationController
  layout false

  def show
    render Users::HeaderNavigations::ShowView.new(
      current_user: current_user,
      current_admin_user: current_admin_user
    )
  end
end

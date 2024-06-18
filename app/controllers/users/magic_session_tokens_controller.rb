class Users::MagicSessionTokensController < ApplicationController
  before_action :feature_enabled!
  before_action :redirect_if_authenticated

  def new
    render Users::MagicSessionTokens::NewView.new(user: User.new)
  end

  def create
    email = params.require(:user).permit(:email).dig(:email).to_s.downcase
    @user = User.find_by(email: email)

    if @user.present?
      MagicSessionTokenNotifier.deliver_to(@user)
    else
      Emails::MagicSessionMailer.no_account_found(email).deliver_later
    end

    redirect_to root_path, notice: "We’ve sent an email with instructions to sign in"
  end

  def show
    render Users::MagicSessionTokens::ShowView.new(user: User.new, magic_session_token: params[:token])
  end

  private

  def feature_enabled!
    redirect_to root_path, notice: "Coming soon!" unless Flipper.enabled?(:user_registration, current_admin_user)
  end
end

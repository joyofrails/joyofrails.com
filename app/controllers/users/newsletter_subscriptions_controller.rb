class Users::NewsletterSubscriptionsController < ApplicationController
  def new
    if current_user&.subscribed_to_newsletter?
      return redirect_to root_path, notice: "You are already subscribed to our newsletter"
    end
    render Users::NewsletterSubscriptions::NewView.new(user: current_user || User.new)
  end

  def create
    create_user_params = params.require(:user).permit(:email)
    @user = User.find_or_initialize_by(email: create_user_params[:email])
    @user.subscribing = true

    if !@user.subscribed_to_newsletter?
      @user.build_newsletter_subscription
      @user.save
    end

    if @user.errors.any?
      return render Users::NewsletterSubscriptions::NewView.new(user: @user), status: :unprocessable_entity
    end

    if @user.needs_confirmation?
      EmailConfirmationNotifier.deliver_to(@user)
    else
      # TODO: Send already subscribed email
    end

    redirect_to root_path, notice: "Welcome to Joy of Rails! Please check your email for confirmation instructions"
  end

  def show
  end

  def unsubscribe
    subscription = find_subscription or raise ActiveRecord::RecordNotFound

    subscription.destroy

    if request.post? && params["List-Unsubscribe"] == "One-Click"
      # must not redirect according to RFC 8058
      # could render show action instead
      render plain: "You have been unsubscribed", status: :ok
    else
      redirect_to root_path, notice: "You have been unsubscribed"
    end
  end

  private

  def find_subscription
    if params[:token]
      NewsletterSubscription.find_by_token_for(:unsubscribe, params[:token])
    elsif current_user&.subscribed_to_newsletter?
      current_user.newsletter_subscription
    end
  end
end

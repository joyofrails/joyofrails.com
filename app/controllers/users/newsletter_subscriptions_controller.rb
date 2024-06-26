class Users::NewsletterSubscriptionsController < ApplicationController
  invisible_captcha only: [:create]

  before_action :authenticate_user_or_not_found!, only: [:index]

  def index
    @newsletter_subscription = current_user.newsletter_subscription || current_user.build_newsletter_subscription

    render Users::NewsletterSubscriptions::ShowView.new(newsletter_subscription: @newsletter_subscription)
  end

  def show
    @newsletter_subscription = NewsletterSubscription.find(params[:id]) or raise ActiveRecord::RecordNotFound

    render Users::NewsletterSubscriptions::ShowView.new(newsletter_subscription: @newsletter_subscription)
  end

  def new
    @newsletter_subscription = current_user&.newsletter_subscription || NewsletterSubscription.new do |ns|
      ns.subscriber = current_user || User.new
    end

    render Users::NewsletterSubscriptions::NewView.new(newsletter_subscription: @newsletter_subscription)
  end

  def create
    create_user_params = params.require(:user).permit(:email)
    @user = User.find_or_initialize_by(email: create_user_params[:email]) do |u|
      u.subscribing = true
    end

    if !@user.subscribed_to_newsletter?
      @user.build_newsletter_subscription
      @user.save
    end

    @newsletter_subscription = @user.newsletter_subscription

    if @user.errors.any?
      return render Users::NewsletterSubscriptions::NewView.new(newsletter_subscription: @newsletter_subscription), status: :unprocessable_entity
    end

    if @user.needs_confirmation?
      EmailConfirmationNotifier.deliver_to(@user)
    else
      # TODO: Send already subscribed email
    end

    redirect_to users_newsletter_subscription_path(@newsletter_subscription),
      notice: "Welcome to Joy of Rails! Please check your email for confirmation instructions"
  end

  def unsubscribe
    if params[:token]
      subscription = NewsletterSubscription.find_by_token_for(:unsubscribe, params[:token]) or raise ActiveRecord::RecordNotFound
      subscription.destroy
    elsif current_user
      # Even though we model the subscription as a has_one, we should destroy
      # all because has_one is not enforced as a constraint
      NewsletterSubscription.where(subscriber: current_user).destroy_all
    else
      not_found!
    end

    if request.post? && params["List-Unsubscribe"] == "One-Click"
      # must not redirect according to RFC 8058
      # could render show action instead
      render plain: "You have been unsubscribed", status: :ok
    else
      redirect_to root_path, notice: "You have been unsubscribed"
    end
  end
end

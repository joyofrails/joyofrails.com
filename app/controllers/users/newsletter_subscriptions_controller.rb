class Users::NewsletterSubscriptionsController < ApplicationController
  # invisible_captcha only: [:create]

  before_action :authenticate_user_or_not_found!, only: [:index, :subscribe]
  before_action :authenticate_user!, only: [:subscribe]
  before_action :redirect_if_authenticated, only: [:create]

  def index
    @newsletter_subscription = current_user.newsletter_subscription || current_user.build_newsletter_subscription

    render Users::NewsletterSubscriptions::ShowView.new(newsletter_subscription: @newsletter_subscription, show_unsubscribe: true)
  end

  def show
    @newsletter_subscription = NewsletterSubscription.find(params[:id]) or raise ActiveRecord::RecordNotFound

    render Users::NewsletterSubscriptions::ShowView.new(newsletter_subscription: @newsletter_subscription, show_unsubscribe: false)
  end

  def new
    user = user_signed_in? ? current_user : User.new
    @newsletter_subscription = user.newsletter_subscription || user.build_newsletter_subscription

    render Users::NewsletterSubscriptions::NewView.new(newsletter_subscription: @newsletter_subscription)
  end

  def create
    create_user_params = params.require(:user).permit(:email)
    @user = User.find_or_initialize_by(email: create_user_params[:email])
    @user.subscribing = true
    @newsletter_subscription = @user.newsletter_subscription || @user.build_newsletter_subscription

    @user.save

    if @user.errors.any?
      return render Users::NewsletterSubscriptions::NewView.new(newsletter_subscription: @newsletter_subscription), status: :unprocessable_entity
    end

    if @user.previously_new_record?
      NewUserNotifier.deliver_to(AdminUser.all, user: @user)
    end

    if @user.needs_confirmation?
      EmailConfirmationNotifier.deliver_to(@user)
    end

    redirect_to users_newsletter_subscription_path(@newsletter_subscription)
  end

  def subscribe
    if !current_user.subscribed_to_newsletter?
      current_user.create_newsletter_subscription
    end

    @newsletter_subscription = current_user.newsletter_subscription

    if current_user.needs_confirmation?
      EmailConfirmationNotifier.deliver_to(current_user)
    end

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Success!" }
      format.turbo_stream { redirect_to users_newsletter_subscription_path(@newsletter_subscription) }
    end
  end

  def unsubscribe
    subscriber = find_subscriber

    # Even though we model the subscription as a has_one, we should destroy
    # all because has_one is not enforced as a constraint
    NewsletterSubscription.where(subscriber: subscriber).destroy_all

    notice = "You have been unsubscribed from the Joy of Rails newsletter"

    if request.post? && params["List-Unsubscribe"] == "One-Click"
      # must not redirect according to RFC 8058
      # could render show action instead
      render plain: notice, status: :ok
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: notice }
        format.turbo_stream {
          redirect_path = current_user ? users_newsletter_subscriptions_path : new_users_newsletter_subscription_path
          redirect_to redirect_path
        }
      end
    end
  end

  private

  def find_subscriber
    subscriber = if params[:token]
      subscription = NewsletterSubscription.find_by_token_for!(:unsubscribe, params[:token])
      subscription&.subscriber
    elsif user_signed_in?
      current_user
    end

    subscriber or raise ActiveRecord::RecordNotFound
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    Honeybadger.event("invalid_token", {path: request.path, controller: self.class.name, action: action_name})
    raise ActiveRecord::RecordNotFound
  end
end

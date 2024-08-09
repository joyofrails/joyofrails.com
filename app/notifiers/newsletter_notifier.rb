class NewsletterNotifier < NotificationEvent
  def self.deliver_to(users, newsletter:, **)
    new(params: {newsletter_id: newsletter.id}).deliver(users, **)
  end

  def deliver_notifications_in_bulk
    newsletter = Newsletter.find(params[:newsletter_id])
    messages = build_newsletter_messages(newsletter)

    PostmarkClient.deliver_messages(messages)

    newsletter.touch(:sent_at)
  end

  private

  def postmark_client
    @postmark_client ||= Postmark::ApiClient.new(Rails.configuration.settings.postmark_api_token)
  end

  def build_newsletter_messages(newsletter)
    recipients.find_each.filter_map do |user|
      if !user.confirmed?
        log_skip(newsletter, user, "user not confirmed")
        next
      end

      unsubscribe_token = user&.newsletter_subscription&.generate_token_for(:unsubscribe)

      if !unsubscribe_token
        log_skip(newsletter, user, "could not generate unsubscribe token")
        next
      end

      Emails::NewsletterMailer.newsletter(newsletter:, user:, unsubscribe_token:)
    end
  end

  def log_skip(newsletter, user, reason)
    Rails.logger.info "#[#{self.class}] Skipping delivery of newsletter #{newsletter.id} for: #{user.class.name}##{user.id} — #{reason}"
  end
end

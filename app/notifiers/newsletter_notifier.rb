class NewsletterNotifier < NotificationEvent
  Error = Class.new(StandardError)

  def self.deliver_to(users, newsletter:, live: false, **)
    new(params: {newsletter_id: newsletter.id, live:}).deliver(users, **)
  end

  def deliver_notifications_in_bulk
    newsletter = Newsletter.find(params[:newsletter_id])
    messages = build_newsletter_messages(newsletter)

    PostmarkClient.deliver_messages(messages)

    newsletter.touch(:sent_at) if deliver_live?
  end

  private

  def deliver_live?
    !!params[:live]
  end

  def build_newsletter_messages(newsletter)
    assert_test_recipients!

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

  def assert_test_recipients!
    return if deliver_live?

    test_recipients = User.test_recipients.pluck(:email)

    if recipients.any? { |user| test_recipients.exclude?(user.email) }
      raise Error, "Attempted to deliver test newsletter to non-test recipients:  #{id}"
    end
  end
end

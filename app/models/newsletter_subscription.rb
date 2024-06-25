class NewsletterSubscription < ApplicationRecord
  belongs_to :subscriber, polymorphic: true, inverse_of: :newsletter_subscription

  generates_token_for :unsubscribe do
    subscriber.email
  end
end

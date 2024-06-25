class NewsletterSubscription < ApplicationRecord
  belongs_to :subscriber, polymorphic: true

  generates_token_for :unsubscribe do
    subscriber.email
  end
end
